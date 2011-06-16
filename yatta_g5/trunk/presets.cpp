#include "presets.h"
#include "layers.h"

TPreset::TPreset(const QString &name, const QString &script, unsigned m, unsigned n, int id)
{
    this->name = name;
    this->script = script;
    this->m = m;
    this->n = n;
    this->fId = id;
}

int TPreset::id() const
{
    return fId;
}

TPreset &TPresets::operator [](int i)
{
    return presets[i];
}

int TPresets::count()
{
    return presets.count();
}

bool TPresets::add(const QString &name, const QString &script, int m, int n, int id)
{
    if (id < 0 || !getPresetById(id)) {
        presets.append(TPreset(name, script, m, n, id));
        return true;
    } else {
        return false;
    }
}

bool TPresets::add(const QString &name, const QString &script, int id)
{
    return add(name, script, 0, 1, id);
}

bool TPresets::remove(int i)
{
    if (layers->isPresetUsed(presets[i].id()))
        return false;

    presets.removeAt(i);
    return true;
}

bool TPresets::removeById(int id)
{
    if (layers->isPresetUsed(id))
        return false;;

    QMutableListIterator<TPreset> i(presets);
    while (i.hasNext())
        if (i.next().id() == id)
            i.remove();
    return true;
}

const TPreset *TPresets::getPresetById(int id)
{
    QListIterator<TPreset> i(presets);
    while (i.hasNext())
        if (i.next().id() == id)
            return &(i.peekPrevious());
    return NULL;

}
