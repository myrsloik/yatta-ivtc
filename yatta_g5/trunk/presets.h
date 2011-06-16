#ifndef PRESETS_H
#define PRESETS_H

#include <QString>
#include <QList>
#include "coreshared.h"

struct TPreset
{
    int id;
    QString name;
    QString script;
    TLayerType type;
    // only used with ptDecimation
    bool scriptDecimation;
    int m;
    int n;
    //
    TPreset(int id, const QString &name, const QString &script, TLayerType type, bool scriptDecimation = false, int m = 0, int n = 1);
    bool operator<(const TPreset &preset) const;
};

class TLayers;

class TPresets
{
private:
    TLayers *layers;
    int maxId;
    QList<TPreset> presets;
public:
    TPresets(TLayers *parent);
    const TPreset &operator [](int i);
    int count();
    bool setName(int i, const QString &name);
    bool setScript(int i, const QString &script, bool scriptDecimation = false, int m = 0, int n = 1);
    bool addDecimationPreset(const QString &name, const QString &script, bool scriptDecimation, int m, int n, int id = -1);
    bool addSectionPreset(const QString &name, const QString &script, int id = -1);
    bool addCustomListPreset(const QString &name, const QString &script, int id = -1);
    bool remove(int i);
    bool removeById(int id);
    const TPreset *getPresetById(int id);
    static const int reservedPresetRange = 1000;
};

#endif // PRESETS_H
