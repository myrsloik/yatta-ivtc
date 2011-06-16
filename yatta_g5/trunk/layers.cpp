#include "layers.h"

TMarkerLayer::TMarkerLayer(TPresets *presets)
{
    this->presets = presets;
}

bool TMarkerLayer::remove(int index)
{
    if (index > 0) {
        sections.removeAt(index);
        return true;
    } else {
        return false;
    }
}

int TMarkerLayer::count()
{
    return sections.count();
}

const TSection &TMarkerLayer::getByFrame(int frame)
{
    QListIterator<TSection> i(sections);
    while (i.hasNext())
        if (i.next().start >= frame)
            return i.peekPrevious();

    //fixme, silences warnings
    return i.peekPrevious();
}

const TSection &TMarkerLayer::operator [](int i)
{
    return sections[i];
}

bool TMarkerLayer::setPreset(int index, int preset)
{
    const TPreset *p = presets->getPresetById(preset);
    if (!p || p->type != layerType())
        return false;
    sections[index].preset = preset;
    return true;
}

bool TMarkerLayer::add(int start, int preset)
{
    const TPreset *p = presets->getPresetById(preset);
    if (!p || p->type != layerType())
        return false;

    // fixme, kinda hacky for file loading but ensures that the section at frame 0 can be "added" on file load just like the other ones
    if (start == 0 && sections.count() == 1)
        return setPreset(0, preset);

    if (getByFrame(start).start != start) {
        sections.append(TSection(start, preset));
        return true;
    }

    return false;
}

bool TMarkerLayer::isPresetUsed(int id) const
{
    QListIterator<TSection> i(sections);
    while (i.hasNext())
        if (i.next().preset == id)
            return true;
    return false;
}

TSectionLayer::TSectionLayer(TPresets *apresets) : TMarkerLayer(apresets)
{
    sections.append(TSection(0, ltSection));
}

TLayerType TSectionLayer::layerType() const
{
    return ltSection;
}

TDecimationLayer::TDecimationLayer(TPresets *apresets) : TMarkerLayer(apresets)
{
    sections.append(TSection(0, ltMatching));
}

TLayerType TDecimationLayer::layerType() const
{
    return ltMatching;
}

TLayers::TLayers() : presets(this)
{

}

TLayers::~TLayers()
{
    QMutableListIterator<TLayer *> i(layers);
    while(i.hasNext()) {
        delete i.next();;
        i.remove();
    }
}
