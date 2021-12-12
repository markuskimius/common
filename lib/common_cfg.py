'''
COMMON: Unix utilities
https://github.com/markuskimius/common

Copyright (c)2020-2021 Mark Kim
Released under GNU General Public License version 2.
https://github.com/markuskimius/common/blob/main/LICENSE
'''

import os
import sys
import json
import getpass
import platform
import common_util

__copyright__ = 'Copyright 2021 Mark Kim'


##############################################################################
# PUBLIC

WORKDIR = os.getenv('WORKDIR', '.')
INDENT = None

def create(*args):
    cfg = CommonCfg()
    cfg.add_filter(ImportFilter())
    cfg.add_filter(PreloadFilter())
    cfg.add_filter(AccountFilter())
    cfg.add_filter(SelectFilter())
    cfg.add_filter(PythonFilter())

    for filepattern in args:
        cfg.open(filepattern)

    return cfg


##############################################################################
# CLASSES

class CommonCfg:
    def __init__(self):
        self.node = JsonNode()
        self.depths = []
        self.filters = []
        self.file_opener = FileOpener()

    def add_filter(self, filter):
        self.filters += [filter]

    def open(self, filepattern):
        json_data = self.file_opener.open(filepattern)
        self.merge(json_data)

        return self

    def merge(self, json_data):
        # Filter the data
        for f in self.filters:
            json_data = f(json_data)

        # Merge the data
        if json_data is not None:
            self.node.merge(json_data)

        return self

    def enter(self, *paths):
        for p in paths:
            self.node = self.node.enter(p)

        self.depths += [len(paths)]

        return self

    def exit(self):
        for i in range(self.depths[-1]):
            self.node = self.node.parent

        self.depths = self.depths[:-1]

    def __enter__(self):
        return self

    def __exit__(self, type, value, traceback):
        self.exit()

    def names(self):
        return self.node.names()

    def get(self, name, default=None):
        path = []

        if isinstance(name,list):
            path = name[:-1]
            name = name[-1]

        with self.enter(*path):
            value = self.node.get(name, default)

        return value

    def __getitem__(self, name):
        return self.node[name]

    def __str__(self):
        return str(self.node)


class FileOpener:
    def open(self, filepatterns):
        merged = None
        cwd = os.getcwd()

        if not isinstance(filepatterns, list):
            filepatterns = [ filepatterns ]

        for pattern in filepatterns:
            for filename in common_util.find(pattern, subdir='etc'):
                # chdir to the filename's directory so we can import files relative to its path
                filename = os.path.abspath(filename)
                dirname = os.path.dirname(filename)
                os.chdir(dirname)

                with open(filename) as f:
                    json_data = json.load(f)

                    merged = common_util.merge_json(merged, json_data)

        os.chdir(cwd)

        return merged


class JsonNode:
    def __init__(self, json_data=None, path=[], parent=None):
        self.json = json_data
        self.path = path
        self.parent = parent

    def merge(self, json_data):
        self.json = common_util.merge_json(self.json, json_data)

        if self.path:
            last = self.path[-1]
            self.parent.json[last] = self.json

        return self

    def enter(self, name):
        next_json = self.json[name]
        next_path = self.path + [name]

        return JsonNode(next_json, path=next_path, parent=self)

    def names(self):
        return self.json.keys()

    def items(self):
        return self.json.items()

    def get(self, name=None, default=None):
        if name is None : return self.json
        else            : return self.json.get(name, default)

    def __getitem__(self, name):
        return self.json[name]

    def __str__(self):
        separators = (',', ':') if INDENT is None else None  # Compact output if INDENT is None

        return json.dumps(self.json, separators=separators, indent=INDENT)


class PreloadFilter:
    def __init__(self):
        self.evaluator = evaluator

    def __call__(self, json_data):
        if isinstance(json_data, dict):
            loaded = None

            for k,v in json_data.items():
                if k == '#preload' : self.evaluator.exec(v)
                else               : json_data[k] = self.__call__(v)

            if '#preload' in json_data:
                del json_data['#preload']

        elif isinstance(json_data, list):
            for i,v in enumerate(json_data):
                json_data[i] = self.__call__(v)

        return json_data


class ImportFilter:
    def __init__(self):
        self.file_opener = FileOpener()

    def __call__(self, json_data):
        if isinstance(json_data, dict):
            included = None

            for k,v in json_data.items():
                if k == '#include' : included = self.file_opener.open(v)
                else               : json_data[k] = self.__call__(v)

            if included is not None:
                del json_data['#include']

                # Recursive import
                included = self(included)

                if json_data : json_data = common_util.merge_dict(included, json_data)
                else         : json_data = included

        elif isinstance(json_data, list):
            for i,v in enumerate(json_data):
                json_data[i] = self.__call__(v)

        return json_data


class AccountFilter:
    def __call__(self, json_data):
        if isinstance(json_data, dict):
            filtered = {}
            matched = None
            username = getpass.getuser()
            hostname = platform.node()

            for k,v in json_data.items():
                if '@' in k:
                    if k == f'{username}@{hostname}' or k == f'{username}@' or k == f'@{hostname}':
                        matched = self.__call__(v)
                else:
                    filtered[k] = self.__call__(v)

            if matched is None : json_data = filtered
            elif filtered      : json_data = common_util.merge_dict(filtered, matched)
            else               : json_data = matched



        elif isinstance(json_data, list):
            for i,v in enumerate(json_data):
                json_data[i] = self.__call__(v)

        return json_data


class SelectFilter:
    def __init__(self):
        self.evaluator = evaluator

    def __call__(self, json_data):
        if isinstance(json_data, dict):
            filtered = dict()

            for k,v in json_data.items():
                if isinstance(k,str) and k.startswith('?'):
                    k = self.evaluator.eval(k[1:])

                if k is not None:
                    filtered[k] = self.__call__(v)

            json_data = filtered

        elif isinstance(json_data, list):
            for i,v in enumerate(json_data):
                json_data[i] = self.__call__(v)

        return json_data


class PythonFilter:
    def __init__(self):
        self.evaluator = evaluator

    def __call__(self, json_data):
        if isinstance(json_data, dict):
            filtered = dict()

            for k,v in json_data.items():
                if isinstance(k,str) and k.startswith('!'):
                    k = k[1:]
                    v = self.evaluator.eval(v)

                filtered[k] = self.__call__(v)

            json_data = filtered

        elif isinstance(json_data, list):
            for i,v in enumerate(json_data):
                json_data[i] = self.__call__(v)

        return json_data


class Evaluator:
    def exec(self, expr):
        if isinstance(expr,list):
            expr = '\n'.join(expr)

        exec(expr, None, None)

    def eval(self, expr):
        if isinstance(expr,list):
            expr = '\n'.join(expr)

        return eval(expr, None, None)


##############################################################################
# SINGLETONS

evaluator = Evaluator()


##############################################################################
# ENTRY POINT

if __name__ == '__main__':
    cfg = create()

    for filename in sys.argv[1:]:
        cfg.open(filename)

    print(cfg)

