extends Node

# Originally from https://godotengine.org/qa/19396/how-do-i-duplicate-a-dictionary-in-godot-3-0-alpha-2

func deep(v):
    var t = typeof(v)

    if t == TYPE_DICTIONARY:
        var d = {}
        for k in v:
            d[k] = deep(v[k])
        return d

    elif t == TYPE_ARRAY:
        var d = []
        d.resize(len(v))
        for i in range(len(v)):
            d[i] = deep(v[i])
        return d

    elif t == TYPE_OBJECT:
        if v.has_method("duplicate"):
            return v.duplicate()
        else:
            print("Found an object, but I don't know how to copy it!")
            return v

    else:
        return v