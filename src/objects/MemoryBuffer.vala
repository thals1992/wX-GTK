// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

using Gee;

public class MemoryBuffer {

    public int position;
    public int capacity;
    int markPosition;
    // public uint8[] backingArray;
    public Gee.List<uint8> backingArray;

    public MemoryBuffer(int size) {
        // backingArray = new uint8[size];
        backingArray = new ArrayList<uint8>.wrap(new uint8[size]);
        position = 0;
        markPosition = 0;
        capacity = size;
    }

    public MemoryBuffer.fromArray(uint8[] ar) {
        // backingArray = ar[0:ar.length];
        backingArray = new ArrayList<uint8>.wrap(ar[0:ar.length]);
        position = 0;
        markPosition = 0;
        capacity = backingArray.size;
    }

    public bool eof() {
        return (position < (capacity - 1)) ? false : true;
    }

    public float getFloat() {
        uint8[] c = {backingArray[position + 3], backingArray[position + 2], backingArray[position + 1], backingArray[position]};
        var f = 0.0f;
        Posix.memcpy(&f, c, 4);
        position += 4;
        return f;
    }

    public float getFloatByIndex(int posn) {
        if ((posn + 3) > (capacity - 1) && (posn + 2) > (capacity - 1) && (posn + 1) > (capacity - 1) && (posn) > (capacity - 1)) {
            return 0.0f;
        }
        if (backingArray == null) {
            return 0.0f;
        }
        // stdout.printf("%d %d %d\n", posn, capacity, backingArray.length);
        uint8[] c = {backingArray[posn + 3], backingArray[posn + 2], backingArray[posn + 1], backingArray[posn]};
        var f = 0.0f;
        Posix.memcpy(&f, c, 4);
        return f;
    }

    public int getIntByIndex(int posn) {
        uint8[] c = {backingArray[posn + 3], backingArray[posn + 2], backingArray[posn + 1], backingArray[posn]};
        var f = 0;
        Posix.memcpy(&f, c, 4);
        return f;
    }

    public void putFloat(double number) {
        var n = (float) number;
        uint8[] c = new uint8[4];
        Posix.memcpy(c, &n, 4);
        backingArray[position + 3] = c[0];
        backingArray[position + 2] = c[1];
        backingArray[position + 1] = c[2];
        backingArray[position + 0] = c[3];
        position += 4;
    }

    public void putInt(int number) {
        var n = number;
        uint8[] c = new uint8[4];
        Posix.memcpy(c, &n, 4);
        backingArray[position + 3] = c[0];
        backingArray[position + 2] = c[1];
        backingArray[position + 1] = c[2];
        backingArray[position + 0] = c[3];
        position += 4;
    }

    public void skipBytes(int count) {
        position += count;
    }

    public int16 getShort() {
        uint8[] c = {backingArray[position + 1], backingArray[position]};
        int16 f = 0;
        Posix.memcpy(&f, c, 2);
        position += 2;
        return f;
    }

    public uint16 getUnsignedShort() {
        uint8[] c = {backingArray[position + 1], backingArray[position]};
        uint16 f = 0;
        Posix.memcpy(&f, c, 2);
        position += 2;
        return f;
    }

    public int getInt() {
        uint8[] c = {backingArray[position + 3], backingArray[position + 2], backingArray[position + 1], backingArray[position]};
        var f = 0;
        Posix.memcpy(&f, c, 4);
        position += 4;
        return f;
    }

    public uint8 get() {
        uint8 value = backingArray[position];
        position += 1;
        return value;
    }

    public void put(uint8 number) {
        backingArray[position] = number;
        position += 1;
    }

    public void putByIndex(int index, uint8 number) {
        backingArray[index] = number;
    }

    public void putSignedShort(int16 number) {
        int16 n = number;
        uint8[] c = new uint8[2];
        Posix.memcpy(c, &n, 2);
        backingArray[position + 1] = c[0];
        backingArray[position + 0] = c[1];
        position += 2;
    }

    public uint8 getByIndex(int posn) {
        if (posn >= capacity) {
            return 0;
        }
        return backingArray[posn];
    }

    public int filePointer() {
        return position;
    }

    public void mark(int index) {
        markPosition = position;
        position = index;
    }

    public void reset() {
        position = markPosition;
    }
}
