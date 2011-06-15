#ifndef PRESETS_H
#define PRESETS_H

#include <QtCore/QString>
#include <QtCore/QList>

class TSectionPreset
{
private:
    int fId;

public:
    QString name;
    QString script;

    TSectionPreset(const QString &name, const QString &script, int id);
    int id();
};

class TDecimationPreset
{
private:
    int fId;

public:
    QString name;
    QString script;
    bool scriptDecimation;
    unsigned int m;
    unsigned int n;

    TDecimationPreset(const QString &name, const QString &script, int id);
    int id();
};

class TSectionPresets
{
private:
    //owner so use can be checked
    QList<TSectionPreset> presets;
public:
    TSectionPreset &operator [](int i) {return presets[i]; }
    int count();
    int add(const QString &name, const QString &script, int id = -1);
    bool remove(int i);
    TSectionPreset & getPresetById(int id);
};

#endif // PRESETS_H
