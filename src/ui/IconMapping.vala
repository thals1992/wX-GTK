// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

public class IconMapping {

    public static string toString(Icon icon) {
        switch (icon) {
            case Icon.Settings:
                return "baseline_settings_black_48dp.png";
            case Icon.Play:
                return "outline_play_arrow_black_48dp.png";
            case Icon.Update:
                return "reload.png";
            case Icon.Left:
                return "baseline_chevron_left_black_48dp.png";
            case Icon.Right:
                return "baseline_chevron_right_black_48dp.png";
            case Icon.Plus:
                return "baseline_zoom_in_black_48dp.png";
            case Icon.Minus:
                return "baseline_zoom_out_black_48dp.png";
            case Icon.Up:
                return "baseline_expand_less_black_48dp.png";
            case Icon.Down:
                return "baseline_expand_more_black_48dp.png";
            case Icon.Delete:
                return "outline_delete_black_48dp.png";
            case Icon.Radar:
                return "baseline_flash_on_black_48dp.png";
            default:
                return "";
        }
    }
}
