#include "presets.h"
#include "layers.h"

TPreset::TPreset(int id, const QString &name, const QString &script, TLayerType type, bool scriptDecimation, int m, int n)
{
    this->id = id;
    this->name = name;
    this->script = script;
    this->type = type;
    this->scriptDecimation = scriptDecimation;
    this->m = m;
    this->n = n;
}

bool TPreset::operator<(const TPreset &preset) const
{
    if (type == preset.type)
        return id < preset.id;
    return type < preset.type;
}

TPresets::TPresets(TLayers *parent)
{
    layers = parent;
    maxId = reservedPresetRange;
    addSectionPreset("Section [empty]", "", ltSection);
    addDecimationPreset("Decimation [0:1]", "", 0, 1, ltMatching);
    addDecimationPreset("Decimation [1:5]", "", 1, 5, ltMatching + 10);
    addCustomListPreset("CL [empty]", "", ltCustomList);
}

const TPreset &TPresets::operator [](int i)
{
    return presets[i];
}

int TPresets::count()
{
    return presets.count();
}

bool TPresets::setName(int i, const QString &name)
{
    if (i <= reservedPresetRange) {
        return false;
    } else {
        presets[i].name = name;
        return true;
    }
}

bool TPresets::setScript(int i, const QString &script, bool scriptDecimation, int m, int n)
{
    if (i <= reservedPresetRange) {
        return false;
    } else {
        presets[i].script = script;
        if (presets[i].type == ltMatching) {
            presets[i].scriptDecimation = scriptDecimation;
            presets[i].m = m;
            presets[i].n = n;
        }
        return true;
    }
}

bool TPresets::addDecimationPreset(const QString &name, const QString &script, bool scriptDecimation, int m, int n, int id)
{
    if (id <= reservedPresetRange || !getPresetById(id)) {
        // fixme, here we have the theoretical possibility that someone will create more than max(int) presets, fuck them
        if (id < 0)
            id = ++maxId;
        else
            maxId = qMax(maxId, id);

        presets.append(TPreset(id, name, script, ltMatching, scriptDecimation, m, n));
        qSort(presets);
        return true;
    } else {
        return false;
    }
}

bool TPresets::addSectionPreset(const QString &name, const QString &script, int id)
{
    if (id <= reservedPresetRange || !getPresetById(id)) {
        // fixme, here we have the theoretical possibility that someone will create more than max(int) presets, fuck them
        if (id < 0)
            id = ++maxId;
        else
            maxId = qMax(maxId, id);

        presets.append(TPreset(id, name, script, ltSection));
        qSort(presets);
        return true;
    } else {
        return false;
    }
}

bool TPresets::addCustomListPreset(const QString &name, const QString &script, int id)
{
    if (id <= reservedPresetRange || !getPresetById(id)) {
        // fixme, here we have the theoretical possibility that someone will create more than max(int) presets, fuck them
        if (id < 0)
            id = ++maxId;
        else
            maxId = qMax(maxId, id);

        presets.append(TPreset(id, name, script, ltCustomList));
        qSort(presets);
        return true;
    } else {
        return false;
    }
}

bool TPresets::remove(int i)
{
    if (presets[i].id <= reservedPresetRange || layers->isPresetUsed(presets[i].id))
        return false;

    presets.removeAt(i);
    return true;
}

bool TPresets::removeById(int id)
{
    if (id <= reservedPresetRange || layers->isPresetUsed(id))
        return false;

    QMutableListIterator<TPreset> i(presets);
    while (i.hasNext())
        if (i.next().id == id)
            i.remove();
    return true;
}

const TPreset *TPresets::getPresetById(int id)
{
    QListIterator<TPreset> i(presets);
    while (i.hasNext())
        if (i.next().id == id)
            return &(i.peekPrevious());
    return NULL;
}
