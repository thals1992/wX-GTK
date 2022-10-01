// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

public class Timer {

    // in Gtk with Glib if the delegate returns false the timer will end
    int speed;
    int count;
    unowned FnInt fn;
    bool autoUpdateOn = false;
    int animationIndex = 0;
    uint timerId = 0;

    public Timer(int speed, int count, FnInt fn) {
        this.speed = speed;
        this.fn = fn;
        this.count = count;
    }

    public void start() {
        autoUpdateOn = true;
        animationIndex = 0;
        timerId = GLib.Timeout.add(speed, runTimer);
    }

    bool runTimer() {
        if (autoUpdateOn) {
            fn(animationIndex);
            animationIndex += 1;
            animationIndex = animationIndex % count;
        } else {
            return false;
        }
        return true;
    }

    public void stop() {
        if (autoUpdateOn) {
            autoUpdateOn = false;
            print(timerId.to_string() + " timer\n");
            if (timerId > 0)
                GLib.Source.remove(timerId);
        }
    }

    public void setSpeed(int speed) {
        this.speed = speed;
    }

    public void setCount(int i) {
        count = i;
    }

    public bool isRunning() {
        return autoUpdateOn;
    }
}
