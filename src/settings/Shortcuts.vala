// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class Shortcuts {

    public const string mainWindow = """
    <?xml version="1.0" encoding="UTF-8"?>
    <interface>
      <object class="GtkShortcutsWindow" id="shortcuts-window">
        <!-- <property name="modal">1</property> -->
        <property name="visible">false</property>
        <property name="modal">true</property>    
        <child>
          <object class="GtkShortcutsSection">
            <property name="visible">true</property>
            <property name="section-name">shortcuts</property>
            <property name="max-height">12</property>
            
            <child>
              <object class="GtkShortcutsGroup">
                <property name="title" translatable="yes"></property>
                <child>
                  <object class="GtkShortcutsShortcut">
                    <property name="accelerator">&lt;ctrl&gt;a</property>
                    <property name="title" translatable="yes">WFO Text (AFD)</property>
                  </object>
                </child>
                <child>
                  <object class="GtkShortcutsShortcut">
                    <property name="accelerator">&lt;ctrl&gt;c</property>
                    <property name="title" translatable="yes">Goes Viewer</property>
                  </object>
                </child>
      
                <child>
                  <object class="GtkShortcutsShortcut">
                    <property name="accelerator">&lt;ctrl&gt;d</property>
                    <property name="title" translatable="yes">Severe dashboard</property>
                  </object>
                </child>
                <child>
                  <object class="GtkShortcutsShortcut">
                    <property name="accelerator">&lt;ctrl&gt;f</property>
                    <property name="title" translatable="yes">Fire weather</property>
                  </object>
                </child>

                <child>
                  <object class="GtkShortcutsShortcut">
                    <property name="accelerator">&lt;ctrl&gt;h</property>
                    <property name="title" translatable="yes">Hourly</property>
                  </object>
                </child>

                <child>
                  <object class="GtkShortcutsShortcut">
                    <property name="accelerator">&lt;ctrl&gt;i</property>
                    <property name="title" translatable="yes">National images</property>
                  </object>
                </child>

                <child>
                  <object class="GtkShortcutsShortcut">
                    <property name="accelerator">&lt;ctrl&gt;l</property>
                    <property name="title" translatable="yes">Lightning</property>
                  </object>
                </child>

                <child>
                  <object class="GtkShortcutsShortcut">
                    <property name="accelerator">&lt;ctrl&gt;m</property>
                    <property name="title" translatable="yes">Radar mosaic</property>
                  </object>
                </child>

              <child>
                <object class="GtkShortcutsShortcut">
                  <property name="accelerator">&lt;ctrl&gt;n</property>
                  <property name="title" translatable="yes">Models (NCEP)</property>
                </object>
              </child>

              <child>
                <object class="GtkShortcutsShortcut">
                  <property name="accelerator">&lt;ctrl&gt;o</property>
                  <property name="title" translatable="yes">NHC</property>
                </object>
              </child>

              <child>
                <object class="GtkShortcutsShortcut">
                  <property name="accelerator">&lt;ctrl&gt;q</property>
                  <property name="title" translatable="yes">Quit program</property>
                </object>
              </child>

              <child>
                <object class="GtkShortcutsShortcut">
                  <property name="accelerator">&lt;ctrl&gt;r</property>
                  <property name="title" translatable="yes">Nexrad radar</property>
                </object>
              </child>

              <child>
                <object class="GtkShortcutsShortcut">
                  <property name="accelerator">&lt;ctrl&gt;s</property>
                  <property name="title" translatable="yes">SPC c onvective outlooks</property>
                </object>
              </child>

              <child>
                <object class="GtkShortcutsShortcut">
                  <property name="accelerator">&lt;ctrl&gt;1</property>
                  <property name="title" translatable="yes">Nexrad radar</property>
                </object>
              </child>


              <child>
                <object class="GtkShortcutsShortcut">
                  <property name="accelerator">&lt;ctrl&gt;2</property>
                  <property name="title" translatable="yes">Nexrad radar - dual pane</property>
                </object>
              </child>


              <child>
                <object class="GtkShortcutsShortcut">
                  <property name="accelerator">&lt;ctrl&gt;4</property>
                  <property name="title" translatable="yes">Nexrad radar - quad pane</property>
                </object>
              </child>

              </object>
            </child>

          </object>
        </child>
      </object>
    </interface>    
    """;

    public const string radar = """
    <?xml version="1.0" encoding="UTF-8"?>
    <interface>
      <object class="GtkShortcutsWindow" id="shortcuts-window">
        <!-- <property name="modal">1</property> -->
        <property name="visible">false</property>
        <property name="modal">true</property>    
        <child>
          <object class="GtkShortcutsSection">
            <property name="visible">true</property>
            <property name="section-name">shortcuts</property>
            <property name="max-height">12</property>
            
            <child>
              <object class="GtkShortcutsGroup">
                <property name="title" translatable="yes">Motion</property>
                <child>
                  <object class="GtkShortcutsShortcut">
                    <property name="accelerator">&lt;ctrl&gt;a</property>
                    <property name="title" translatable="yes">Start/stop animation</property>
                  </object>
                </child>
                <child>
                  <object class="GtkShortcutsShortcut">
                    <property name="accelerator">&lt;ctrl&gt;u</property>
                    <property name="title" translatable="yes">Start/stop auto update</property>
                  </object>
                </child>
      
                <child>
                  <object class="GtkShortcutsShortcut">
                    <property name="accelerator">&lt;ctrl&gt;Left</property>
                    <property name="title" translatable="yes">Pan left</property>
                  </object>
                </child>
                <child>
                  <object class="GtkShortcutsShortcut">
                    <property name="accelerator">&lt;ctrl&gt;Right</property>
                    <property name="title" translatable="yes">Pan right</property>
                  </object>
                </child>

                <child>
                  <object class="GtkShortcutsShortcut">
                    <property name="accelerator">&lt;ctrl&gt;Down</property>
                    <property name="title" translatable="yes">Pan down</property>
                  </object>
                </child>

              <child>
                <object class="GtkShortcutsShortcut">
                  <property name="accelerator">&lt;ctrl&gt;Up</property>
                  <property name="title" translatable="yes">Pan up</property>
                </object>
              </child>

              <child>
                <object class="GtkShortcutsShortcut">
                  <property name="accelerator">&lt;ctrl&gt;plus</property>
                  <property name="title" translatable="yes">Zoom in</property>
                </object>
              </child>

            <child>
              <object class="GtkShortcutsShortcut">
                <property name="accelerator">&lt;ctrl&gt;minus</property>
                <property name="title" translatable="yes">Zoom out</property>
              </object>
            </child>

              </object>
            </child>

          </object>
        </child>
      </object>
    </interface>    
    """;

}
