#include "layers.h"

TMarkerLayer::TMarkerLayer(TPresets &apresets) : presets(apresets)
{

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
    TSection &s = sections[i];
    s.index = i;
    if (i + 1 < sections.count())
        s.end = sections[i + 1].start - 1;
    else
        s.end = -1;
    return s;
}

bool TMarkerLayer::setPreset(int index, int preset)
{
    const TPreset *p = presets.getPresetById(preset);
    if (!p || p->type != layerType())
        return false;
    sections[index].preset = preset;
    return true;
}

bool TMarkerLayer::add(int start, int preset)
{
    const TPreset *p = presets.getPresetById(preset);
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

TSectionLayer::TSectionLayer(TPresets &apresets) : TMarkerLayer(apresets)
{
    sections.append(TSection(0, ltSection));
}

TLayerType TSectionLayer::layerType() const
{
    return ltSection;
}

TDecimationLayer::TDecimationLayer(TPresets &apresets) : TMarkerLayer(apresets)
{
    sections.append(TSection(0, ltMatching));
}

TLayerType TDecimationLayer::layerType() const
{
    return ltMatching;
}

TCustomListLayer::TCustomListLayer(TPresets &apresets) : presets(apresets)
{
    fPreset = ltCustomList;
}

int TCustomListLayer::preset() const
{
    return fPreset;
}

bool TCustomListLayer::setPreset(int preset)
{
    const TPreset *p = presets.getPresetById(preset);
    if (!p || p->type != layerType())
        return false;

    fPreset = preset;
    return true;
}

bool TCustomListLayer::add(int start, int end)
{
    // fixme, overlap check
    ranges.append(TCustomRange(start, end));
    return true;
}

void TCustomListLayer::remove(int index)
{
    remove(index);
}

int TCustomListLayer::count()
{
    return ranges.count();
}

const TCustomRange *TCustomListLayer::getByFrame(int frame)
{
    QListIterator<TCustomRange> i(ranges);
    while (i.hasNext()) {
        const TCustomRange &c = i.next();
        if (c.start >= frame && c.end <= frame)
            return &c;
    }
    return NULL;
}

const TCustomRange &TCustomListLayer::operator [](int i)
{
    return ranges[i];
}

TLayerType TCustomListLayer::layerType() const
{
    return ltCustomList;
}

bool TCustomListLayer::isPresetUsed(int id) const
{
    return fPreset == id;
}

bool TLayers::isPresetUsed(int id)
{
    QListIterator<TLayer *> i(layers);
    while (i.hasNext()) {
        if (i.next()->isPresetUsed(id))
            return true;
    }
    return false;
}

int TLayers::count()
{
    return layers.count();
}

void TLayers::exchange(int i1, int i2)
{
    layers.swap(i1, i2);
}

const TLayer &TLayers::operator [](int i)
{
    return *(layers[i]);
}

int TLayers::customListLayerCount()
{
    int n = 0;
    QListIterator<TLayer *> i(layers);
    while (i.hasNext())
        if (i.next()->layerType() == ltCustomList)
            n++;
    return n;
}

int TLayers::sectionLayerCount()
{
    int n = 0;
    QListIterator<TLayer *> i(layers);
    while (i.hasNext())
        if (i.next()->layerType() == ltCustomList)
            n++;
    return n;
}

TDecimationLayer &TLayers::decimationLayer()
{
    QListIterator<TLayer *> i(layers);
    while (i.hasNext()) {
        if (i.next()->layerType() == ltMatching)
            return *static_cast<TDecimationLayer *>(i.peekPrevious());
    }
}

TSectionLayer &TLayers::sectionLayer(int index)
{
    int j = 0;
    QListIterator<TLayer *> i(layers);
    while (i.hasNext()) {
        if (i.next()->layerType() == ltMatching && j++ == index)
            return *static_cast<TSectionLayer *>(i.peekPrevious());
    }
}

TCustomListLayer &TLayers::customListLayer(int index)
{
    int j = 0;
    QListIterator<TLayer *> i(layers);
    while (i.hasNext()) {
        if (i.next()->layerType() == ltMatching && j++ == index)
            return *static_cast<TCustomListLayer *>(i.peekPrevious());
    }
}

TLayers::TLayers() : presets(this)
{
    layers.append(new TDecimationLayer(presets));
}

TLayers::~TLayers()
{
    QMutableListIterator<TLayer *> i(layers);
    while(i.hasNext()) {
        delete i.next();;
        i.remove();
    }
}
