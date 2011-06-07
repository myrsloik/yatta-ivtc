#ifndef PRESETS_H
#define PRESETS_H

#include <QtCore/QString>

struct TDecimationRate
{
    unsigned int m;
    unsigned int n;
};

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
    TDecimationRate decimationRate;

    TDecimationPreset(const QString &name, const QString &script, int id);
    int id();
};

#endif // PRESETS_H
