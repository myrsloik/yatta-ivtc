#ifndef PRESETS_H
#define PRESETS_H

#include <QString>
#include <QList>

class TPreset
{
private:
    int fId;
public:
    QString name;
    QString script;
    TPreset(const QString &name, const QString &script, int id);
    int id() const;
};

class TDecimationPreset : public TPreset
{
    unsigned m;
    unsigned n;
    bool scriptDecimation;
    TDecimationPreset(const QString &name, const QString &script, unsigned m, unsigned n, bool scriptDecimation, int id);
};

class TLayers;

class TPresets
{
private:
    TLayers *layers;
    QList<TPreset> presets;
public:
    TPreset &operator [](int i);
    int count();
    bool add(const QString &name, const QString &script, int m, int n, int id = -1);
    bool add(const QString &name, const QString &script, int id = -1);
    bool remove(int i);
    bool removeById(int id);
    const TPreset *getPresetById(int id);
};

#endif // PRESETS_H
