local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local graphPanel = grafana.graphPanel;
local annotation = grafana.annotation;
local text = grafana.text;
local template = grafana.template;
local timepicker = grafana.timepicker;
local prometheus = grafana.prometheus;
local row = grafana.row;
local singlestat = grafana.singlestat;
local tablePanel = grafana.tablePanel;


dashboard.new(
  'Memory Overview',
  time_from='now-12h',
  editable=false,
  refresh= "1m",
  graphTooltip='shared_crosshair',
  schemaVersion=18,
  version=1,
  tags=['Percona','OS'],
  iteration=1559114330686,
  uid="gJqbbm-ik",
  timepicker = timepicker.new(
    hidden=false,
  )
)
.addAnnotation(
  grafana.annotation.datasource(
    'PMM Annotations',
    '-- Grafana --',
    enable=true,
    hide=false,
    type='tags',
    builtIn=1,
    iconColor='#e0752d',
    limit=100,
    tags = ["pmm_annotation",
            "$host",
            "$service"],
  )
)
.addAnnotation(
  grafana.annotation.datasource(
    'Annotations & Alerts',
    '-- Grafana --',
    enable=true,
    hide=true,
    type='dashboard',
    builtIn=1,
    iconColor='#6ed0e0',
    limit=100,
  )
)
.addLink(
  grafana.link.dashboards(
    'Query Analytics',
    ['QAN'],
    type='link',
    url='/graph/d/7w6Q3PJmz/pmm-query-analytics',
    keepTime=true,
    includeVars=true,
    asDropdown=false,
    icon='dashboard',
  )
)
.addLink(
  grafana.link.dashboards(
    'OS',
    ['OS'],
    keepTime=true,
    includeVars=true,
  )
)
.addLink(
  grafana.link.dashboards(
    'MySQL',
    ['MySQL'],
    keepTime=true,
    includeVars=true,
  )
)
.addLink(
  grafana.link.dashboards(
    'MongoDB',
    ['MongoDB'],
    keepTime=true,
    includeVars=true,
  )
)
.addLink(
  grafana.link.dashboards(
    'PostgreSQL',
    ['PostgreSQL'],
    keepTime=true,
    includeVars=true,
  )
)
.addLink(
  grafana.link.dashboards(
    'HA',
    ['HA'],
    keepTime=true,
    includeVars=true,
  )
)
.addLink(
  grafana.link.dashboards(
    'Insight',
    ['Insight'],
    keepTime=true,
    includeVars=true,
  )
)
.addLink(
  grafana.link.dashboards(
    'PMM',
    ['PMM'],
    keepTime=true,
    includeVars=true,
  )
)
.addTemplate(
    template.interval('interval', 'auto,1s,5s,1m,5m,1h,6h,1d', 'auto', label='Interval', auto_count=200, auto_min='1s'),
)
.addTemplate(
  template.new(
  'host',
  'Prometheus',
  'label_values(node_boot_time_seconds, node_name)',
  label='Host',
  refresh='load',
  sort=0,
  multi=false,
  skipUrlSync=false,
  definition='label_values(node_boot_time_seconds, node_name)',
  includeAll=false,
  ),
)
.addPanel(
  text.new(
    content='<h1><i><font color=#5991A7><b><center>Data for </font><font color=#e68a00>$host</font> <font color=#5991A7> with</font> </font><font color=#e68a00>$interval</font> <font color=#5991A7>resolution</center></b></font></i></h1>',
    mode='html',
  ),
  gridPos={
        "h": 2,
        "w": 24,
        "x": 0,
        "y": 0,
      },
  style=null,
)//238 text
.addPanel(
    row.new(
      title='Total',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 2,
    },
    style=null,
)//231 row
.addPanel(
  graphPanel.new(
    'Memory Usage',//title
    description='Basic memory usage',
    fill=2,
    decimals=2,
    linewidth=2,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    legend_sort='avg',
    legend_sortDesc=true,
    legend_sideWidth=350,
    maxPerRow=6,
    stack=true,
    formatY1='bytes',
    minY1='0',
    sort='decreasing',
    aliasColors={
        "Apps": "#629E51",
        "Buffers": "#614D93",
        "Cache": "#6D1F62",
        "Cached": "#511749",
        "Committed": "#508642",
        "Free": "#0A437C",
        "Harware Corrupted - Amount of RAM that the kernel identified as corrupted / not working": "#CFFAFF",
        "Inactive": "#584477",
        "PageTables": "#0A50A1",
        "Page_Tables": "#0A50A1",
        "RAM_Free": "#E0F9D7",
        "SWAP Used": "#BF1B00",
        "Slab": "#806EB7",
        "Slab_Cache": "#E0752D",
        "Swap": "#BF1B00",
        "Swap Used": "#BF1B00",
        "Swap_Cache": "#C15C17",
        "Swap_Free": "#2F575E",
        "Unused": "#EAB839"
      },
  )
  .addSeriesOverride(
    {
      "alias": "Total",
      "color": "#bf1b00",
      "fill": 0,
      "points": true,
      "stack": false
    }
  )
  .addTarget(
      prometheus.target(
        'max_over_time(node_memory_MemTotal_bytes{node_name=~"$host"}[$interval]) or
        max_over_time(node_memory_MemTotal_bytes{node_name=~"$host"}[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Total',
        step=240,
      )
  )
  .addTarget(
      prometheus.target(
        'max(node_memory_MemTotal_bytes{node_name=~"$host"}) without(job) -
        (max(node_memory_MemFree_bytes{node_name=~"$host"}) without(job) +
        max(node_memory_Buffers_bytes{node_name=~"$host"}) without(job) +
        (max(node_memory_Cached_bytes{node_name=~"$host",job=~"rds-enhanced|linux"}) without (job) or
        max(node_memory_Cached_bytes{node_name=~"$host",job="rds-basic"}) without (job)))',
        interval='$interval',
        legendFormat='Used',
        intervalFactor=1,
        step=240,
      )
  )
  .addTarget(
      prometheus.target(
        'max(node_memory_Cached_bytes{node_name=~"$host",job=~"rds-enhanced|linux"}) without (job) or
        max(node_memory_Cached_bytes{node_name=~"$host",job=~"rds-basic"}) without (job)',
        interval='$interval',
        legendFormat='Cached',
        intervalFactor=1,
        step=240,
      )
  )
  .addTarget(
      prometheus.target(
        'max_over_time(node_memory_MemFree_bytes{node_name=~"$host"}[$interval]) or max_over_time(node_memory_MemFree_bytes{node_name=~"$host"}[5m])',
        interval='$interval',
        legendFormat='Free',
        intervalFactor=1,
        step=240,
      )
  )
  .addTarget(
      prometheus.target(
        '(max_over_time(node_memory_SwapTotal_bytes{node_name=~"$host"}[$interval]) or max_over_time(node_memory_SwapTotal_bytes{node_name=~"$host"}[5m])) -
        (max_over_time(node_memory_SwapFree_bytes{node_name=~"$host"}[$interval]) or max_over_time(node_memory_SwapFree_bytes{node_name=~"$host"}[5m]))',
        interval='$interval',
        legendFormat='Used Swap',
        intervalFactor=1,
        step=240,
      )
  )
  .addTarget(
      prometheus.target(
        'max_over_time(node_memory_Buffers_bytes{node_name=~"$host"}[$interval]) or max_over_time(node_memory_Buffers_bytes{node_name=~"$host"}[5m])',
        interval='$interval',
        legendFormat='Buffers',
        intervalFactor=1,
        step=240,
      )
  ),
  gridPos={
    "h": 8,
    "w": 12,
    "x": 0,
    "y": 3,
  },
  style=null,
)//78 graph
.addPanel(
  graphPanel.new(
    'Free Memory Percent',//title
    fill=1,
    decimals=null,
    linewidth=1,
    bars=true,
    lines=false,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    legend_sort='avg',
    legend_sortDesc=true,
    stack=true,
    formatY1='percent',
  )
  .addTarget(
      prometheus.target(
        '(max_over_time(node_memory_MemFree_bytes{node_name=~"$host"}[$interval]) or max_over_time(node_memory_MemFree_bytes{node_name=~"$host"}[5m])) * 100 /
        (max_over_time(node_memory_MemTotal_bytes{node_name=~"$host"}[$interval]) or max_over_time(node_memory_MemTotal_bytes{node_name=~"$host"}[$interval]))',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Free',
      )
  ),
  gridPos={
    "h": 8,
    "w": 12,
    "x": 12,
    "y": 3,
  },
  style=null,
)//240 graph
.addPanel(
    row.new(
      title='VMM Statistic',
      collapse=true,
    )
    .addPanel(
      graphPanel.new(
        'Total Pages Size',//title
        description='**Inactive** - Memory which has been less recently used.  It is more eligible to be reclaimed for other purposes\n\n**Active** - Memory that has been used more recently and usually not reclaimed unless absolutely necessary',
        fill=2,
        decimals=2,
        linewidth=2,
        datasource='Prometheus',
        pointradius=5,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        legend_sideWidth=350,
        maxPerRow=2,
        value_type='cumulative',
        formatY1='bytes',
        minY1='0',
        aliasColors={
            "Apps": "#629E51",
            "Buffers": "#614D93",
            "Cache": "#6D1F62",
            "Cached": "#511749",
            "Committed": "#508642",
            "Free": "#0A437C",
            "Harware Corrupted - Amount of RAM that the kernel identified as corrupted / not working": "#CFFAFF",
            "Inactive": "#584477",
            "PageTables": "#0A50A1",
            "Page_Tables": "#0A50A1",
            "RAM_Free": "#E0F9D7",
            "Slab": "#806EB7",
            "Slab_Cache": "#E0752D",
            "Swap": "#BF1B00",
            "Swap_Cache": "#C15C17",
            "Swap_Free": "#2F575E",
            "Unused": "#EAB839"
          },
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_Inactive_bytes{node_name=~"$host"}[$interval]) or
            max_over_time(node_memory_Inactive_bytes{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Inactive',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_Active_bytes{node_name=~"$host"}[$interval]) or
            max_over_time(node_memory_Active_bytes{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Active',
            step=240,
          )
      ),
      gridPos={
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 12,
      }
    )//136 graph
    .addPanel(
      graphPanel.new(
        'Anonymous Memory Size',//title
        description='**Inactive** Anonymous and swap cache on inactive LRU list, including tmpfs (shmem)\n\n**Active**  Anonymous and swap cache on active least-recently-used (LRU) list, including tmpfs',
        fill=2,
        decimals=2,
        linewidth=2,
        datasource='Prometheus',
        pointradius=5,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        legend_sideWidth=350,
        maxPerRow=6,
        sort='decreasing',
        value_type='cumulative',
        format='bytes',
        min='0',
        aliasColors={
                        "Apps": "#629E51",
                        "Buffers": "#614D93",
                        "Cache": "#6D1F62",
                        "Cached": "#511749",
                        "Committed": "#508642",
                        "Free": "#0A437C",
                        "Harware Corrupted - Amount of RAM that the kernel identified as corrupted / not working": "#CFFAFF",
                        "Inactive": "#584477",
                        "Page_Tables": "#0A50A1",
                        "PageTables": "#0A50A1",
                        "RAM_Free": "#E0F9D7",
                        "Slab": "#806EB7",
                        "Slab_Cache": "#E0752D",
                        "Swap": "#BF1B00",
                        "Swap_Cache": "#C15C17",
                        "Swap_Free": "#2F575E",
                        "Unused": "#EAB839"
                    },
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_Active_anon_bytes{node_name=~"$host"}[$interval]) or max_over_time(node_memory_Active_anon_bytes{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Active',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_Inactive_anon_bytes{node_name=~"$host"}[$interval]) or max_over_time(node_memory_Inactive_anon_bytes{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Inactive',
            step=240,
          )
      ),
      gridPos={
        "h": 8,
        "w": 12,
        "x": 12,
        "y": 12,
      }
    )//241 graph
    .addPanel(
      graphPanel.new(
        'File Cache Memory Size',//title
        description='**Inactive**  File-backed memory on inactive LRU list\n\n**Active** File-backed memory on active LRU list',
        fill=2,
        decimals=2,
        linewidth=2,
        datasource='Prometheus',
        pointradius=5,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        legend_sideWidth=350,
        maxPerRow=6,
        value_type='cumulative',
        format='bytes',
        sort='decreasing',
        min='0',
        aliasColors={
            "Apps": "#629E51",
            "Buffers": "#614D93",
            "Cache": "#6D1F62",
            "Cached": "#511749",
            "Committed": "#508642",
            "Free": "#0A437C",
            "Harware Corrupted - Amount of RAM that the kernel identified as corrupted / not working": "#CFFAFF",
            "Inactive": "#584477",
            "PageTables": "#0A50A1",
            "Page_Tables": "#0A50A1",
            "RAM_Free": "#E0F9D7",
            "Slab": "#806EB7",
            "Slab_Cache": "#E0752D",
            "Swap": "#BF1B00",
            "Swap_Cache": "#C15C17",
            "Swap_Free": "#2F575E",
            "Unused": "#EAB839"
          },
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_Inactive_file_bytes{node_name=~"$host"}[$interval]) or max_over_time(node_memory_Inactive_file_bytes{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Inactive',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_Active_file_bytes{node_name=~"$host"}[$interval]) or max_over_time(node_memory_Active_file_bytes{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Active',
            step=240,
          )
      ),
      gridPos={
        "h": 8,
         "w": 12,
         "x": 0,
         "y": 20,
      }
    )//191 graph
    .addPanel(
      graphPanel.new(
        'Swap Activity',//title
        description='',
        fill=2,
        decimals=2,
        linewidth=2,
        datasource='Prometheus',
        pointradius=5,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        legend_sideWidth=350,
        sort='decreasing',
        maxPerRow=6,
        value_type='cumulative',
        decimalsY1=2,
        labelY1='Swap out (-) / Swap in (+)',
        formatY1='Bps',
        formatY2='bytes',
        minY2='0',
        aliasColors={
            "Apps": "#629E51",
            "Buffers": "#614D93",
            "Cache": "#6D1F62",
            "Cached": "#511749",
            "Committed": "#508642",
            "Free": "#0A437C",
            "Harware Corrupted - Amount of RAM that the kernel identified as corrupted / not working": "#CFFAFF",
            "Inactive": "#584477",
            "PageTables": "#0A50A1",
            "Page_Tables": "#0A50A1",
            "RAM_Free": "#E0F9D7",
            "Slab": "#806EB7",
            "Slab_Cache": "#E0752D",
            "Swap": "#BF1B00",
            "Swap_Cache": "#C15C17",
            "Swap_Free": "#2F575E",
            "Unused": "#EAB839"
          },
      )
      .addSeriesOverride({
              "alias": "Total",
              "color": "#bf1b00",
              "legend": false,
              "lines": false
            })
      .addSeriesOverride({
              "alias": "Swap Out (Writes)",
              "transform": "negative-Y"
            })
      .addTarget(
          prometheus.target(
            'rate(node_vmstat_pswpin{node_name=~"$host"}[$interval]) * 4096 or irate(node_vmstat_pswpin{node_name=~"$host"}[5m]) * 4096',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Swap In (Reads)',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'rate(node_vmstat_pswpout{node_name=~"$host"}[$interval]) * 4096 or irate(node_vmstat_pswpout{node_name=~"$host"}[5m]) * 4096',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Swap Out (Writes)',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            '(rate(node_vmstat_pswpin{node_name=~"$host"}[$interval]) * 4096 or
              irate(node_vmstat_pswpin{node_name=~"$host"}[5m]) * 4096) +
              (rate(node_vmstat_pswpout{node_name=~"$host"}[$interval]) * 4096 or
              irate(node_vmstat_pswpout{node_name=~"$host"}[5m]) * 4096)',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Total',
          )
      ),
      gridPos={
        "h": 8,
         "w": 12,
         "x": 12,
         "y": 20,
      }
    )//255 graph
    .addPanel(
      graphPanel.new(
        'Swap Space',//title
        description='',
        fill=2,
        decimals=2,
        linewidth=2,
        datasource='Prometheus',
        pointradius=5,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        legend_sideWidth=350,
        sort='decreasing',
        maxPerRow=6,
        value_type='cumulative',
        format='bytes',
        min='0',
        aliasColors={
            "Apps": "#629E51",
            "Buffers": "#614D93",
            "Cache": "#6D1F62",
            "Cached": "#511749",
            "Committed": "#508642",
            "Free": "#0A437C",
            "Harware Corrupted - Amount of RAM that the kernel identified as corrupted / not working": "#CFFAFF",
            "Inactive": "#584477",
            "PageTables": "#0A50A1",
            "Page_Tables": "#0A50A1",
            "RAM_Free": "#E0F9D7",
            "Slab": "#806EB7",
            "Slab_Cache": "#E0752D",
            "Swap": "#BF1B00",
            "Swap_Cache": "#C15C17",
            "Swap_Free": "#2F575E",
            "Unused": "#EAB839"
          },
      )
      .addSeriesOverride({
              "alias": "Total",
              "color": "#bf1b00",
              "legend": false,
              "lines": false
            })
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_SwapTotal_bytes{node_name=~"$host"}[$interval]) - max_over_time(node_memory_SwapFree_bytes{node_name=~"$host"}[$interval]) or
            max_over_time(node_memory_SwapTotal_bytes{node_name=~"$host"}[5m]) - max_over_time(node_memory_SwapFree_bytes{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Used',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_SwapFree_bytes{node_name=~"$host"}[$interval]) or max_over_time(node_memory_SwapFree_bytes{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Free',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_SwapTotal_bytes{node_name=~"$host"}[$interval]) or max_over_time(node_memory_SwapTotal_bytes{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Total',
          )
      ),
      gridPos={
        "h": 8,
         "w": 12,
         "x": 0,
          "y": 28,
      }
    )//254 graph
    ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 11,
    },
    style=null,
)//244 row
.addPanel(
    row.new(
      title='Memory Statistics',
      collapse=true,
    )
    .addPanel(
      graphPanel.new(
        'Memory Usage Types',//title
        description='**PageTables**  Memory used to map between virtual and physical memory addresses\n\n**AnonPages** Non-file backed pages mapped into userspace page tables\n\n**SwapCache**  Memory that keeps track of pages that have been fetched from swap but not yet been modified\n\n**Slab**  Memory used by the kernel to cache data structures for its own use (caches like inode, dentry, etc)\n\n**Swap**  Swap space used\n\n**Harware Corrupted** Amount of RAM that the kernel identified as corrupted / not working\n\n**Mapped** Files which have been mmaped, such as libraries\n\n**Dirty** Memory which is waiting to get written back to the disk\n\n**Writeback** Memory which is actively being written back to the disk\n\n**WritebackTmp** Memory used by FUSE for temporary writeback buffers\n\n**Shmem** Total memory used by shared memory (shmem) and tmpfs',
        fill=0,
        decimals=2,
        linewidth=2,
        datasource='Prometheus',
        pointradius=5,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        legend_rightSide=true,
        sort='decreasing',
        maxPerRow=6,
        stack=true,
        formatY1='bytes',
        minY1='0',
        aliasColors={
            "Apps": "#629E51",
            "Buffers": "#614D93",
            "Cache": "#6D1F62",
            "Cached": "#511749",
            "Committed": "#508642",
            "Free": "#0A437C",
            "Harware Corrupted - Amount of RAM that the kernel identified as corrupted / not working": "#CFFAFF",
            "Inactive": "#584477",
            "PageTables": "#0A50A1",
            "Page_Tables": "#0A50A1",
            "RAM_Free": "#E0F9D7",
            "Slab": "#806EB7",
            "Slab_Cache": "#E0752D",
            "Swap": "#BF1B00",
            "Swap - Swap memory usage": "#BF1B00",
            "Swap_Cache": "#C15C17",
            "Swap_Free": "#2F575E",
            "Unused": "#EAB839",
            "Unused - Free memory unassigned": "#052B51"
          },
      )
      .addSeriesOverride({
              "alias": "/.*Harware Corrupted - *./",
              "stack": false
            })
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_PageTables_bytes{node_name=~"$host"}[$interval]) or max_over_time(node_memory_PageTables_bytes{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='PageTables',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_SwapCached_bytes{node_name=~"$host"}[$interval]) or max_over_time(node_memory_SwapCached_bytes{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='SwapCached',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_Slab_bytes{node_name=~"$host"}[$interval]) or max_over_time(node_memory_Slab_bytes{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Slab',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_SwapTotal_bytes{node_name=~"$host"}[$interval]) - max_over_time(node_memory_SwapFree_bytes{node_name=~"$host"}[$interval])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Swap',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_HardwareCorrupted_bytes{node_name=~"$host"}[$interval]) or max_over_time(node_memory_HardwareCorrupted_bytes{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Harware Corrupted',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_Mapped_bytes{node_name=~"$host"}[$interval]) or max_over_time(node_memory_Mapped_bytes{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Mapped',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_Dirty_bytes{node_name=~"$host"}[$interval]) or max_over_time(node_memory_Dirty_bytes{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Dirty',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_Writeback_bytes{node_name=~"$host"}[$interval]) or max_over_time(node_memory_Writeback_bytes{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Writeback',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_Shmem_bytes{node_name=~"$host"}[$interval]) or max_over_time(node_memory_Shmem_bytes{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Shmem',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_AnonPages_bytes{node_name=~"$host"}[$interval]) or max_over_time(node_memory_AnonPages_bytes{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='AnonPages',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_Writeback_bytesTmp_bytes{node_name=~"$host"}[$interval]) or max_over_time(node_memory_Writeback_bytesTmp_bytes{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='WritebackTmp',
          )
      ),
      gridPos={
          "h": 8,
          "w": 24,
          "x": 0,
          "y": 13,
      }
    )//24 graph
    .addPanel(
      graphPanel.new(
        'Vmalloc',//title
        description='**Total** total size of vmalloc memory area\n\n**Used** amount of vmalloc area which is used\n\n**Chunk** largest contiguous block of vmalloc area which is free',
        fill=2,
        decimals=2,
        linewidth=2,
        datasource='Prometheus',
        pointradius=5,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        legend_rightSide=false,
        maxPerRow=6,
        stack=true,
        formatY1='bytes',
        minY1='0',
        decimalsY1=2,
        aliasColors={
            "Active": "#99440A",
            "Buffers": "#58140C",
            "Cache": "#6D1F62",
            "Cached": "#511749",
            "Committed": "#508642",
            "Dirty": "#6ED0E0",
            "Free": "#B7DBAB",
            "Inactive": "#EA6460",
            "Mapped": "#052B51",
            "PageTables": "#0A50A1",
            "Page_Tables": "#0A50A1",
            "Slab_Cache": "#EAB839",
            "Swap": "#BF1B00",
            "Swap_Cache": "#C15C17",
            "Total": "#511749",
            "Total RAM": "#052B51",
            "Total RAM + Swap": "#052B51",
            "VmallocUsed": "#EA6460"
          },
      )
      .addTarget(
          prometheus.target(
            'node_memory_VmallocChunk_bytes{node_name=~"$host"}',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Chunk',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'node_memory_VmallocTotal_bytes{node_name=~"$host"}',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Total',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'node_memory_VmallocUsed_bytes{node_name=~"$host"}',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Used',
            step=240,
          )
      ),
      gridPos={
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 21,
      }
    )//70 graph
    .addPanel(
      graphPanel.new(
        'Shared Memory',//title
        description='**Total** Memory used by shared memory (shmem) and tmpfs\n\n**HugePages** Memory used by shared memory (shmem) and tmpfs allocated with huge pages\n\n**PmdMapped**  Shared memory mapped into userspace with huge pages',
        fill=2,
        decimals=2,
        linewidth=2,
        datasource='Prometheus',
        pointradius=5,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        legend_rightSide=false,
        legend_sideWidth=350,
        value_type='cumulative',
        maxPerRow=6,
        stack=true,
        formatY1='bytes',
        minY1='0',
        aliasColors={
            "Apps": "#629E51",
            "Buffers": "#614D93",
            "Cache": "#6D1F62",
            "Cached": "#511749",
            "Committed": "#508642",
            "Free": "#0A437C",
            "Harware Corrupted - Amount of RAM that the kernel identified as corrupted / not working": "#CFFAFF",
            "Inactive": "#584477",
            "PageTables": "#0A50A1",
            "Page_Tables": "#0A50A1",
            "RAM_Free": "#E0F9D7",
            "Slab": "#806EB7",
            "Slab_Cache": "#E0752D",
            "Swap": "#BF1B00",
            "Swap_Cache": "#C15C17",
            "Swap_Free": "#2F575E",
            "Unused": "#EAB839"
          },
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_Shmem_bytes{node_name=~"$host"}[$interval]) or max_over_time(node_memory_Shmem_bytes{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Total',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_Shmem_bytesHugePages{node_name=~"$host"}[$interval]) or max_over_time(node_memory_Shmem_bytesHugePages{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='HugePages',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_Shmem_bytesPmdMapped{node_name=~"$host"}[$interval]) or max_over_time(node_memory_Shmem_bytesPmdMapped{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='PmdMapped',
          )
      ),
      gridPos={
        "h": 8,
        "w": 12,
        "x": 12,
        "y": 21,
      }
    )//138 graph
    .addPanel(
      graphPanel.new(
        'Kernel Memory Stack',//title
        description='',
        fill=2,
        decimals=2,
        linewidth=2,
        datasource='Prometheus',
        pointradius=5,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        legend_rightSide=false,
        legend_sideWidth=350,
        maxPerRow=2,
        value_type='cumulative',
        formatY1='bytes',
        minY1='0',
        aliasColors={
            "Apps": "#629E51",
            "Buffers": "#614D93",
            "Cache": "#6D1F62",
            "Cached": "#511749",
            "Committed": "#508642",
            "Free": "#0A437C",
            "Harware Corrupted - Amount of RAM that the kernel identified as corrupted / not working": "#CFFAFF",
            "Inactive": "#584477",
            "PageTables": "#0A50A1",
            "Page_Tables": "#0A50A1",
            "RAM_Free": "#E0F9D7",
            "Slab": "#806EB7",
            "Slab_Cache": "#E0752D",
            "Swap": "#BF1B00",
            "Swap_Cache": "#C15C17",
            "Swap_Free": "#2F575E",
            "Unused": "#EAB839"
          },
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_KernelStack_bytes{node_name=~"$host"}[$interval]) or max_over_time(node_memory_KernelStack_bytes{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Total',
            step=240,
          )
      ),
      gridPos={
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 29,
      }
    )//160 graph
    .addPanel(
      graphPanel.new(
        'Committed Memory',//title
        description='**Committed_AS**  Amount of memory presently allocated on the system\n\n**CommitLimit**  Amount of  memory currently available to be allocated on the system',
        fill=2,
        decimals=2,
        linewidth=2,
        datasource='Prometheus',
        pointradius=5,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        legend_rightSide=false,
        legend_sideWidth=350,
        maxPerRow=6,
        value_type='cumulative',
        formatY1='bytes',
        minY1='0',
        aliasColors={
            "Apps": "#629E51",
            "Buffers": "#614D93",
            "Cache": "#6D1F62",
            "Cached": "#511749",
            "Committed": "#508642",
            "Free": "#0A437C",
            "Harware Corrupted - Amount of RAM that the kernel identified as corrupted / not working": "#CFFAFF",
            "Inactive": "#584477",
            "PageTables": "#0A50A1",
            "Page_Tables": "#0A50A1",
            "RAM_Free": "#E0F9D7",
            "Slab": "#806EB7",
            "Slab_Cache": "#E0752D",
            "Swap": "#BF1B00",
            "Swap_Cache": "#C15C17",
            "Swap_Free": "#2F575E",
            "Unused": "#EAB839"
          },
      )
      .addSeriesOverride( {
              "alias": "/.*Committed_AS - *./"
            })
      .addSeriesOverride({
              "alias": "/.*CommitLimit - *./",
              "color": "#BF1B00",
              "fill": 0
            })
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_Committed_AS_bytes{node_name=~"$host"}[$interval]) or
            max_over_time(node_memory_Committed_AS_bytes{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Committed_AS',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_CommitLimit_bytes{node_name=~"$host"}[$interval]) or
            max_over_time(node_memory_CommitLimit_bytes{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='CommitLimit',
            step=240,
          )
      ),
      gridPos={
        "h": 8,
        "w": 12,
        "x": 12,
        "y": 29,
      }
    )//135 graph
    .addPanel(
      graphPanel.new(
        'Non-file Backed Pages Size',//title
        description='**AnonPages** Non-file backed pages mapped into userspace page tables\n\n**AnonHugePages** Non-file backed huge pages mapped into userspace page tables',
        fill=2,
        decimals=2,
        linewidth=2,
        datasource='Prometheus',
        pointradius=5,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        legend_rightSide=false,
        maxPerRow=6,
        stack=true,
        formatY1='bytes',
        minY1='0',
        aliasColors={
            "Active": "#99440A",
            "Buffers": "#58140C",
            "Cache": "#6D1F62",
            "Cached": "#511749",
            "Committed": "#508642",
            "Dirty": "#6ED0E0",
            "Free": "#B7DBAB",
            "Inactive": "#EA6460",
            "Mapped": "#052B51",
            "PageTables": "#0A50A1",
            "Page_Tables": "#0A50A1",
            "Slab_Cache": "#EAB839",
            "Swap": "#BF1B00",
            "Swap_Cache": "#C15C17",
            "Total": "#511749",
            "Total RAM": "#052B51",
            "Total RAM + Swap": "#052B51",
            "VmallocUsed": "#EA6460"
          },
      )
      .addSeriesOverride(  {
              "alias": "/.*Inactive *./",
              "transform": "negative-Y"
            })
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_AnonHugePages_bytes{node_name=~"$host"}[$interval]) or max_over_time(node_memory_AnonHugePages_bytes{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='AnonHugePages',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_AnonPages_bytes{node_name=~"$host"}[$interval]) or max_over_time(node_memory_AnonPages_bytes{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='AnonPages',
            step=240,
          )
      ),
      gridPos={
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 37,
      }
    )//129 graph
    .addPanel(
      graphPanel.new(
        'Kernel Cache',//title
        description='**Slab** in-kernel data structures cache\n**SReclaimable** Part of Slab, that might be reclaimed, such as caches\n **SUnreclaim** Part of Slab, that cannot be reclaimed on memory pressure',
        fill=2,
        decimals=2,
        linewidth=2,
        datasource='Prometheus',
        pointradius=5,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        legend_rightSide=false,
        legend_sideWidth=350,
        maxPerRow=6,
        value_type='cumulative',
        stack=true,
        formatY1='bytes',
        minY1='0',
        aliasColors= {
            "Apps": "#629E51",
            "Buffers": "#614D93",
            "Cache": "#6D1F62",
            "Cached": "#511749",
            "Committed": "#508642",
            "Free": "#0A437C",
            "Harware Corrupted - Amount of RAM that the kernel identified as corrupted / not working": "#CFFAFF",
            "Inactive": "#584477",
            "PageTables": "#0A50A1",
            "Page_Tables": "#0A50A1",
            "RAM_Free": "#E0F9D7",
            "Slab": "#806EB7",
            "Slab_Cache": "#E0752D",
            "Swap": "#BF1B00",
            "Swap_Cache": "#C15C17",
            "Swap_Free": "#2F575E",
            "Unused": "#EAB839"
          },
      )
      .addSeriesOverride({
              "alias": "Total",
              "color": "#bf1b00",
              "fill": 0,
              "points": true,
              "stack": false
            })
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_Slab_bytes{node_name=~"$host"}[$interval]) or max_over_time(node_memory_Slab_bytes{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Total',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_SReclaimable_bytes{node_name=~"$host"}[$interval]) or max_over_time(node_memory_SReclaimable_bytes{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='SReclaimable',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_SUnreclaim_bytes{node_name=~"$host"}[$interval]) or max_over_time(node_memory_SUnreclaim_bytes{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='SUnreclaim',
          )
      ),
      gridPos={
        "h": 8,
        "w": 12,
        "x": 12,
        "y": 37,
      }
    )//242 graph
    .addPanel(
      graphPanel.new(
        'DirectMap Pages',//title
        description='',
        fill=2,
        decimals=2,
        linewidth=2,
        datasource='Prometheus',
        pointradius=5,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        legend_rightSide=false,
        maxPerRow=6,
        stack=true,
        formatY1='bytes',
        minY1='0',
        aliasColors={
            "Active": "#99440A",
            "Buffers": "#58140C",
            "Cache": "#6D1F62",
            "Cached": "#511749",
            "Committed": "#508642",
            "Dirty": "#6ED0E0",
            "Free": "#B7DBAB",
            "Inactive": "#EA6460",
            "Mapped": "#052B51",
            "PageTables": "#0A50A1",
            "Page_Tables": "#0A50A1",
            "Slab_Cache": "#EAB839",
            "Swap": "#BF1B00",
            "Swap_Cache": "#C15C17",
            "Total": "#511749",
            "Total RAM": "#052B51",
            "Total RAM + Swap": "#052B51",
            "VmallocUsed": "#EA6460"
          },
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_DirectMap1G_bytes{node_name=~"$host"}[$interval]) or max_over_time(node_memory_DirectMap1G_bytes{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Page Size 1G',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_DirectMap2M_bytes{node_name=~"$host"}[$interval]) or max_over_time(node_memory_DirectMap2M_bytes{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Page Size 2M',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_DirectMap4k_bytes{node_name=~"$host"}[$interval]) or max_over_time(node_memory_DirectMap4k_bytes{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Page Size 4K',
            step=240,
          )
      ),
      gridPos={
        "h": 8,
          "w": 12,
          "x": 0,
          "y": 45,
      }
    )//128 graph
    .addPanel(
      graphPanel.new(
        'Bounce Memory',//title
        description='**Bounce** Memory used for block device \"bounce buffers\"',
        fill=2,
        decimals=2,
        linewidth=2,
        datasource='Prometheus',
        pointradius=5,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        legend_rightSide=false,
        legend_sideWidth=350,
        value_type='cumulative',
        maxPerRow=6,
        formatY1='bytes',
        minY1='0',
        aliasColors={
            "Apps": "#629E51",
            "Buffers": "#614D93",
            "Cache": "#6D1F62",
            "Cached": "#511749",
            "Committed": "#508642",
            "Free": "#0A437C",
            "Harware Corrupted - Amount of RAM that the kernel identified as corrupted / not working": "#CFFAFF",
            "Inactive": "#584477",
            "PageTables": "#0A50A1",
            "Page_Tables": "#0A50A1",
            "RAM_Free": "#E0F9D7",
            "Slab": "#806EB7",
            "Slab_Cache": "#E0752D",
            "Swap": "#BF1B00",
            "Swap_Cache": "#C15C17",
            "Swap_Free": "#2F575E",
            "Unused": "#EAB839"
          },
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_Bounce_bytes{node_name=~"$host"}[$interval]) or max_over_time(node_memory_Bounce_bytes{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Total',
            step=240,
          )
      ),
      gridPos={
        "h": 8,
          "w": 12,
          "x": 12,
          "y": 45,
      }
    )//159 graph
    .addPanel(
      graphPanel.new(
        'NFS Pages Size',//title
        description='**NFS_Unstable** NFS pages sent to the server, but not yet committed to stable storage',
        fill=2,
        decimals=2,
        linewidth=1,
        datasource='Prometheus',
        pointradius=5,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        legend_rightSide=false,
        maxPerRow=6,
        formatY1='bytes',
        minY1='0',
        aliasColors={
            "Active": "#99440A",
            "Buffers": "#58140C",
            "Cache": "#6D1F62",
            "Cached": "#511749",
            "Committed": "#508642",
            "Dirty": "#6ED0E0",
            "Free": "#B7DBAB",
            "Inactive": "#EA6460",
            "Mapped": "#052B51",
            "PageTables": "#0A50A1",
            "Page_Tables": "#0A50A1",
            "Slab_Cache": "#EAB839",
            "Swap": "#BF1B00",
            "Swap_Cache": "#C15C17",
            "Total": "#511749",
            "Total RAM": "#052B51",
            "Total RAM + Swap": "#052B51",
            "Total Swap": "#614D93",
            "VmallocUsed": "#EA6460"
          },
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_NFS_Unstable_bytes{node_name=~"$host"}[$interval]) or max_over_time(node_memory_NFS_Unstable_bytes{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='NFS Unstable',
            step=240,
          )
      ),
      gridPos={
          "h": 8,
          "w": 12,
          "x": 0,
          "y": 53,
      }
    )//132 graph
    .addPanel(
      graphPanel.new(
        'Unevictable/MLocked Memory',//title
        description="**Unevictable** Amount of unevictable memory that can't be swapped out for a variety of reasons\n\n**MLocked** Size of pages locked to memory using the mlock() system call",
        fill=2,
        decimals=2,
        linewidth=2,
        datasource='Prometheus',
        pointradius=5,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        legend_rightSide=false,
        legend_sideWidth=350,
        stack=true,
        maxPerRow=6,
        value_type='cumulative',
        formatY1='bytes',
        minY1='0',
        aliasColors={
            "Apps": "#629E51",
            "Buffers": "#614D93",
            "Cache": "#6D1F62",
            "Cached": "#511749",
            "Committed": "#508642",
            "Free": "#0A437C",
            "Harware Corrupted - Amount of RAM that the kernel identified as corrupted / not working": "#CFFAFF",
            "Inactive": "#584477",
            "PageTables": "#0A50A1",
            "Page_Tables": "#0A50A1",
            "RAM_Free": "#E0F9D7",
            "Slab": "#806EB7",
            "Slab_Cache": "#E0752D",
            "Swap": "#BF1B00",
            "Swap_Cache": "#C15C17",
            "Swap_Free": "#2F575E",
            "Unused": "#EAB839"
          },
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_Unevictable_bytes{node_name=~"$host"}[$interval]) or max_over_time(node_memory_Unevictable_bytes{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Unevictable',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_Mlocked_bytes{node_name=~"$host"}[$interval]) or max_over_time(node_memory_Mlocked_bytes{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='MLocked',
            step=240,
          )
      ),
      gridPos={
          "h": 8,
          "w": 12,
          "x": 12,
          "y": 53,
      }
    )//137 graph
    .addPanel(
      graphPanel.new(
        'Huge Pages Size',//title
        description='**HugePages** Total size of the pool of huge pages\n\n**Hugepagesize**  Huge Page size',
        fill=2,
        decimals=2,
        linewidth=1,
        datasource='Prometheus',
        pointradius=5,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        legend_rightSide=false,
        maxPerRow=2,
        value_type='individual',
        formatY1='bytes',
        decimalsY2=0,
        minY1='0',
        aliasColors={
            "Active": "#99440A",
            "Buffers": "#58140C",
            "Cache": "#6D1F62",
            "Cached": "#511749",
            "Committed": "#508642",
            "Dirty": "#6ED0E0",
            "Free": "#B7DBAB",
            "Inactive": "#EA6460",
            "Mapped": "#052B51",
            "PageTables": "#0A50A1",
            "Page_Tables": "#0A50A1",
            "Slab_Cache": "#EAB839",
            "Swap": "#BF1B00",
            "Swap_Cache": "#C15C17",
            "Total": "#511749",
            "Total RAM": "#806EB7",
            "Total RAM + Swap": "#806EB7",
            "VmallocUsed": "#EA6460"
          },
      )
      .addSeriesOverride({
              "alias": "HugePages",
              "yaxis": 2
            })
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_HugePages_Total{node_name=~"$host"}[$interval]) or max_over_time(node_memory_HugePages_Total_bytes{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='HugePages',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_Hugepagesize_bytes{node_name=~"$host"}[$interval]) or max_over_time(node_memory_Hugepagesize_bytes{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Hugepagesize',
            step=240,
          )
      ),
      gridPos={
          "h": 8,
            "w": 12,
            "x": 0,
            "y": 61
      }
    )//71 graph
    .addPanel(
      graphPanel.new(
        'HugePages Statistic',//title
        description='**Total** Number of hugepages being allocated by the kernel (Defined with vm.nr_hugepages)\n\n**Free** The number of hugepages not being allocated by a process\n\n**Surp**  The number of hugepages in the pool above the value in vm.nr_hugepages. The maximum number of surplus hugepages is controlled by vm.nr_overcommit_hugepages.\n\n**Rsvd**  The number of  huge pages for which a commitment to allocate from the pool has been made, but no allocation has yet been made',
        fill=2,
        decimals=2,
        linewidth=1,
        datasource='Prometheus',
        pointradius=1,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        legend_rightSide=false,
        maxPerRow=6,
        stack=true,
        value_type='individual',
        decimalsY1=0,
        minY1='0',
        aliasColors={
            "Active": "#99440A",
            "Buffers": "#58140C",
            "Cache": "#6D1F62",
            "Cached": "#511749",
            "Committed": "#508642",
            "Dirty": "#6ED0E0",
            "Free": "#B7DBAB",
            "Inactive": "#EA6460",
            "Mapped": "#052B51",
            "PageTables": "#0A50A1",
            "Page_Tables": "#0A50A1",
            "Slab_Cache": "#EAB839",
            "Swap": "#BF1B00",
            "Swap_Cache": "#C15C17",
            "Total": "#511749",
            "Total RAM": "#806EB7",
            "Total RAM + Swap": "#806EB7",
            "VmallocUsed": "#EA6460"
          },
      )
      .addSeriesOverride( {
              "alias": "Total",
              "color": "#C4162A",
              "legend": false,
              "lines": false,
              "pointradius": 1,
              "points": true,
              "stack": false
            })
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_HugePages_Free{node_name=~"$host"}[$interval]) or max_over_time(node_memory_HugePages_Free{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Free',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_HugePages_Rsvd{node_name=~"$host"}[$interval]) or max_over_time(node_memory_HugePages_Rsvd{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Reserved',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_HugePages_Surp{node_name=~"$host"}[$interval]) or max_over_time(node_memory_HugePages_Surp{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Surplus',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_HugePages_Total{node_name=~"$host"}[$interval]) or max_over_time(node_memory_HugePages_Total{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Total',
            step=240,
          )
      ),
      gridPos={
          "h": 8,
            "w": 12,
            "x": 12,
            "y": 61
      }
    )//140 graph
    ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 12,
    },
    style=null,
)//234 row
.addPanel(
    row.new(
      title='Number and Dynamic of Pages',
      collapse=true,
    )
    .addPanel(
      graphPanel.new(
        'Memory Pages',//title
        description='',
        fill=2,
        decimals=2,
        linewidth=2,
        datasource='Prometheus',
        pointradius=5,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        legend_sideWidth=350,
        maxPerRow=6,
        value_type='cumulative',
        decimalsY1=2,
        labelY1='Pages',
        logBase1Y=2,
        minY1='0',
        aliasColors={
            "Apps": "#629E51",
            "Buffers": "#614D93",
            "Cache": "#6D1F62",
            "Cached": "#511749",
            "Committed": "#508642",
            "Free": "#0A437C",
            "Harware Corrupted - Amount of RAM that the kernel identified as corrupted / not working": "#CFFAFF",
            "Inactive": "#584477",
            "PageTables": "#0A50A1",
            "Page_Tables": "#0A50A1",
            "RAM_Free": "#E0F9D7",
            "Slab": "#806EB7",
            "Slab_Cache": "#E0752D",
            "Swap": "#BF1B00",
            "Swap_Cache": "#C15C17",
            "Swap_Free": "#2F575E",
            "Unused": "#EAB839"
          },
      )
      .addTarget(
          prometheus.target(
            'node_vmstat_nr_free_pages{node_name=~"$host"}',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Free',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'rate(node_vmstat_pgactivate{node_name=~"$host"}[$interval])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Activated',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(node_vmstat_pgdeactivate{node_name=~"$host"}[$interval])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Deactivated',
          )
      ),
      gridPos={
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 14,
      }
    )//186 graph
    .addPanel(
      graphPanel.new(
        'IO activity',//title
        description='',
        fill=2,
        linewidth=2,
        datasource='Prometheus',
        pointradius=5,
        legend_values=false,
        legend_min=false,
        legend_max=false,
        legend_avg=false,
        legend_alignAsTable=false,
        legend_show=true,
        value_type='individual',
        labelY1='Pages',
        logBase1Y=2,
      )
      .addTarget(
          prometheus.target(
            'rate(node_vmstat_pgpgin{node_name=~"$host"}[$interval])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='In',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(node_vmstat_pgpgout{node_name=~"$host"}[$interval])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Out',
          )
      ),
      gridPos={
        "h": 8,
        "w": 12,
        "x": 12,
        "y": 14,
      }
    )//248 graph
    .addPanel(
      graphPanel.new(
        'Cache Pages',//title
        description='',
        fill=2,
        decimals=2,
        linewidth=2,
        datasource='Prometheus',
        pointradius=5,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        legend_sideWidth=350,
        maxPerRow=6,
        value_type='cumulative',
        decimalsY1=2,
        labelY1='Pages',
        formatY1='bytes',
        minY1='0',
        aliasColors={
            "Apps": "#629E51",
            "Buffers": "#614D93",
            "Cache": "#6D1F62",
            "Cached": "#511749",
            "Committed": "#508642",
            "Free": "#0A437C",
            "Harware Corrupted - Amount of RAM that the kernel identified as corrupted / not working": "#CFFAFF",
            "Inactive": "#584477",
            "PageTables": "#0A50A1",
            "Page_Tables": "#0A50A1",
            "RAM_Free": "#E0F9D7",
            "Slab": "#806EB7",
            "Slab_Cache": "#E0752D",
            "Swap": "#BF1B00",
            "Swap_Cache": "#C15C17",
            "Swap_Free": "#2F575E",
            "Unused": "#EAB839"
          },
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_vmstat_nr_active_file{node_name=~"$host"}[$interval]) or max_over_time(node_vmstat_nr_active_file{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Active',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_vmstat_nr_inactive_file{node_name=~"$host"}[$interval]) or max_over_time(node_vmstat_nr_inactive_file{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Inactive',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_vmstat_nr_isolated_file{node_name=~"$host"}[$interval]) or max_over_time(node_vmstat_nr_isolated_file{node_name=~"$host"}[$interval])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Isolated',
          )
      ),
      gridPos={
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 22,
      }
    )//228 graph
    .addPanel(
      graphPanel.new(
        'Anonymous Memory Pages',//title
        description='',
        fill=2,
        decimals=2,
        linewidth=2,
        datasource='Prometheus',
        pointradius=5,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_current=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        legend_sideWidth=350,
        maxPerRow=6,
        value_type='cumulative',
        decimalsY1=2,
        labelY1='Pages',
        logBase1Y=2,
        minY1='0',
        aliasColors={
            "Apps": "#629E51",
            "Buffers": "#614D93",
            "Cache": "#6D1F62",
            "Cached": "#511749",
            "Committed": "#508642",
            "Free": "#0A437C",
            "Harware Corrupted - Amount of RAM that the kernel identified as corrupted / not working": "#CFFAFF",
            "Inactive": "#e5ac0e",
            "PageTables": "#0A50A1",
            "Page_Tables": "#0A50A1",
            "RAM_Free": "#E0F9D7",
            "Slab": "#806EB7",
            "Slab_Cache": "#E0752D",
            "Swap": "#BF1B00",
            "Swap_Cache": "#C15C17",
            "Swap_Free": "#2F575E",
            "Unused": "#EAB839"
          },
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_vmstat_nr_active_anon{node_name=~"$host"}[$interval]) or max_over_time(node_vmstat_nr_active_anon{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Active',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_vmstat_nr_inactive_anon{node_name=~"$host"}[$interval]) or max_over_time(node_vmstat_nr_inactive_anon{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Inactive',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_vmstat_nr_isolated_anon{node_name=~"$host"}[$interval]) or max_over_time(node_vmstat_nr_isolated_anon{node_name=~"$host"}[$interval])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Isolated',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_vmstat_nr_anon_transparent_hugepages{node_name=~"$host"}[$interval]) or max_over_time(node_vmstat_nr_anon_transparent_hugepages{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Transparent Huge Pages',
          )
      ),
      gridPos={
        "h": 8,
        "w": 12,
        "x": 12,
        "y": 22,
      }
    )//185 graph
    .addPanel(
      graphPanel.new(
        'Shmem Pages',//title
        description='',
        fill=2,
        decimals=2,
        linewidth=2,
        datasource='Prometheus',
        pointradius=5,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        legend_sideWidth=350,
        maxPerRow=6,
        value_type='cumulative',
        labelY1='Pages',
        minY1='0',
        aliasColors={
            "Apps": "#629E51",
            "Buffers": "#614D93",
            "Cache": "#6D1F62",
            "Cached": "#511749",
            "Committed": "#508642",
            "Free": "#0A437C",
            "Harware Corrupted - Amount of RAM that the kernel identified as corrupted / not working": "#CFFAFF",
            "Inactive": "#584477",
            "PageTables": "#0A50A1",
            "Page_Tables": "#0A50A1",
            "RAM_Free": "#E0F9D7",
            "Slab": "#806EB7",
            "Slab_Cache": "#E0752D",
            "Swap": "#BF1B00",
            "Swap_Cache": "#C15C17",
            "Swap_Free": "#2F575E",
            "Unused": "#EAB839"
          },
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_vmstat_nr_shmem{node_name=~"$host"}[$interval]) or max_over_time(node_vmstat_nr_shmem{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Pages',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_vmstat_nr_shmem_hugepages{node_name=~"$host"}[$interval]) or max_over_time(node_vmstat_nr_shmem_hugepages{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Hugepages',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_vmstat_nr_shmem_pmdmapped{node_name=~"$host"}[$interval]) or max_over_time(node_vmstat_nr_shmem_pmdmapped{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Pmdmapped',
          )
      ),
      gridPos={
          "h": 8,
          "w": 12,
          "x": 0,
          "y": 30,
      }
    )//214 graph
    .addPanel(
      graphPanel.new(
        'Dirty Pages',//title
        description='',
        fill=2,
        decimals=2,
        linewidth=2,
        datasource='Prometheus',
        pointradius=5,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        legend_sideWidth=350,
        maxPerRow=6,
        value_type='cumulative',
        labelY1='Pages',
        logBase1Y=2,
        minY1='0',
        sort='increasing',
        aliasColors={
            "Apps": "#629E51",
            "Buffers": "#614D93",
            "Cache": "#6D1F62",
            "Cached": "#511749",
            "Committed": "#508642",
            "Free": "#0A437C",
            "Harware Corrupted - Amount of RAM that the kernel identified as corrupted / not working": "#CFFAFF",
            "Inactive": "#584477",
            "PageTables": "#0A50A1",
            "Page_Tables": "#0A50A1",
            "RAM_Free": "#E0F9D7",
            "Slab": "#806EB7",
            "Slab_Cache": "#E0752D",
            "Swap": "#BF1B00",
            "Swap_Cache": "#C15C17",
            "Swap_Free": "#2F575E",
            "Unused": "#EAB839"
          },
      )
      .addSeriesOverride({
              "alias": "/^Threshold.*/",
              "legend": false,
              "lines": false
            })
      .addTarget(
          prometheus.target(
            'max_over_time(node_vmstat_nr_dirty{node_name=~"$host"}[$interval]) or max_over_time(node_vmstat_nr_dirty{node_name=~"$host"}[5m ])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Total',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_vmstat_nr_dirty_threshold{node_name=~"$host"}[$interval]) or max_over_time(node_vmstat_nr_dirty_threshold{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Threshold',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_vmstat_nr_dirty_background_threshold{node_name=~"$host"}[$interval]) or max_over_time(node_vmstat_nr_dirty_background_threshold{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Threshold (Backgroud)',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_vmstat_nr_writeback{node_name=~"$host"}[$interval]) or max_over_time(node_vmstat_nr_writeback{node_name=~"$host"}[5m ])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Writeback',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_vmstat_nr_unstable{node_name=~"$host"}[$interval]) or max_over_time(node_vmstat_nr_unstable{node_name=~"$host"}[5m ])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Unstable',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_vmstat_nr_writeback_temp{node_name=~"$host"}[$interval]) or max_over_time(node_vmstat_nr_writeback_temp{node_name=~"$host"}[5m ])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Writeback (Temporary )',
            step=240,
          )
      ),
      gridPos={
          "h": 8,
          "w": 12,
          "x": 12,
          "y": 30,
      }
    )//245 graph
    .addPanel(
      graphPanel.new(
        'Pages Allocated to Page Tables',//title
        description='',
        fill=2,
        decimals=2,
        linewidth=2,
        datasource='Prometheus',
        pointradius=5,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        legend_sideWidth=350,
        maxPerRow=6,
        value_type='cumulative',
        labelY1='Pages',
        minY1='0',
        aliasColors={
            "Apps": "#629E51",
            "Buffers": "#614D93",
            "Cache": "#6D1F62",
            "Cached": "#511749",
            "Committed": "#508642",
            "Free": "#0A437C",
            "Harware Corrupted - Amount of RAM that the kernel identified as corrupted / not working": "#CFFAFF",
            "Inactive": "#584477",
            "PageTables": "#0A50A1",
            "Page_Tables": "#0A50A1",
            "RAM_Free": "#E0F9D7",
            "Slab": "#806EB7",
            "Slab_Cache": "#E0752D",
            "Swap": "#BF1B00",
            "Swap_Cache": "#C15C17",
            "Swap_Free": "#2F575E",
            "Unused": "#EAB839"
          },
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_vmstat_nr_page_table_pages{node_name=~"$host"}[$interval]) or max_over_time(node_vmstat_nr_page_table_pages{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Total',
            step=240,
          )
      ),
      gridPos={
        "h": 8,
         "w": 12,
         "x": 0,
         "y": 38,
      }
    )//209 graph
    .addPanel(
      graphPanel.new(
        'Bounce Buffer Pages',//title
        description='',
        fill=2,
        decimals=2,
        linewidth=2,
        datasource='Prometheus',
        pointradius=5,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        legend_sideWidth=350,
        maxPerRow=6,
        sort='increasing',
        value_type='cumulative',
        labelY1='Pages',
        logBase1Y=2,
        decimalsY1=0,
        minY1='0',
        aliasColors={
            "Apps": "#629E51",
            "Buffers": "#614D93",
            "Cache": "#6D1F62",
            "Cached": "#511749",
            "Committed": "#508642",
            "Free": "#0A437C",
            "Harware Corrupted - Amount of RAM that the kernel identified as corrupted / not working": "#CFFAFF",
            "Inactive": "#584477",
            "PageTables": "#0A50A1",
            "Page_Tables": "#0A50A1",
            "RAM_Free": "#E0F9D7",
            "Slab": "#806EB7",
            "Slab_Cache": "#E0752D",
            "Swap": "#BF1B00",
            "Swap_Cache": "#C15C17",
            "Swap_Free": "#2F575E",
            "Unused": "#EAB839"
          },
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_vmstat_nr_bounce{node_name=~"$host"}[$interval]) or max_over_time(node_vmstat_nr_bounce{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Total',
            step=240,
          )
      ),
      gridPos={
        "h": 8,
         "w": 12,
         "x": 12,
         "y": 38,
      }
    )//218 graph
    .addPanel(
      graphPanel.new(
        'Misc Pages',//title
        description='',
        fill=2,
        decimals=2,
        linewidth=2,
        datasource='Prometheus',
        pointradius=5,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        legend_sideWidth=350,
        maxPerRow=6,
        value_type='cumulative',
        labelY1='Pages',
        minY1='0',
        aliasColors={
            "Apps": "#629E51",
            "Buffers": "#614D93",
            "Cache": "#6D1F62",
            "Cached": "#511749",
            "Committed": "#508642",
            "Free": "#0A437C",
            "Harware Corrupted - Amount of RAM that the kernel identified as corrupted / not working": "#CFFAFF",
            "Inactive": "#584477",
            "PageTables": "#0A50A1",
            "Page_Tables": "#0A50A1",
            "RAM_Free": "#E0F9D7",
            "Slab": "#806EB7",
            "Slab_Cache": "#E0752D",
            "Swap": "#BF1B00",
            "Swap_Cache": "#C15C17",
            "Swap_Free": "#2F575E",
            "Unused": "#EAB839"
          },
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_vmstat_nr_free_cma{node_name=~"$host"}[$interval]) or max_over_time(node_vmstat_nr_free_cma{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Free Contiguous',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_vmstat_nr_vmscan_write{node_name=~"$host"}[$interval]) or max_over_time(node_vmstat_nr_vmscan_write{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Written by VM scanner',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_vmstat_nr_vmscan_immediate_reclaim{node_name=~"$host"}[$interval]) or max_over_time(node_vmstat_nr_vmscan_immediate_reclaim{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Immediately Reclaimed',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_vmstat_nr_unevictable{node_name=~"$host"}[$interval]) or max_over_time(node_vmstat_nr_unevictable{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Unevictable',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_vmstat_nr_mlock{node_name=~"$host"}[$interval]) or max_over_time(node_vmstat_nr_mlock{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Mlock',
          )
      ),
      gridPos={
        "h": 8,
         "w": 12,
         "x": 0,
         "y": 46,
      }
    )//204 graph
    .addPanel(
      graphPanel.new(
        'Pages Mapped by Files',//title
        description='',
        fill=2,
        decimals=2,
        linewidth=2,
        datasource='Prometheus',
        pointradius=5,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        legend_sideWidth=350,
        sort='increasing',
        maxPerRow=6,
        value_type='cumulative',
        labelY1='Pages',
        minY1='0',
        aliasColors={
            "Apps": "#629E51",
            "Buffers": "#614D93",
            "Cache": "#6D1F62",
            "Cached": "#511749",
            "Committed": "#508642",
            "Free": "#0A437C",
            "Harware Corrupted - Amount of RAM that the kernel identified as corrupted / not working": "#CFFAFF",
            "Inactive": "#584477",
            "PageTables": "#0A50A1",
            "Page_Tables": "#0A50A1",
            "RAM_Free": "#E0F9D7",
            "Slab": "#806EB7",
            "Slab_Cache": "#E0752D",
            "Swap": "#BF1B00",
            "Swap_Cache": "#C15C17",
            "Swap_Free": "#2F575E",
            "Unused": "#EAB839"
          },
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_vmstat_nr_mapped{node_name=~"$host"}[$interval]) or max_over_time(node_vmstat_nr_mapped{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Total',
            step=240,
          )
      ),
      gridPos={
        "h": 8,
         "w": 12,
         "x": 12,
         "y": 46,
      }
    )//246 graph
    .addPanel(
      graphPanel.new(
        'Kernel Stack Pages',//title
        description='',
        fill=2,
        decimals=2,
        linewidth=2,
        datasource='Prometheus',
        pointradius=5,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        legend_sideWidth=350,
        maxPerRow=6,
        value_type='cumulative',
        labelY1='Pages',
        minY1='0',
        aliasColors={
            "Apps": "#629E51",
            "Buffers": "#614D93",
            "Cache": "#6D1F62",
            "Cached": "#511749",
            "Committed": "#508642",
            "Free": "#0A437C",
            "Harware Corrupted - Amount of RAM that the kernel identified as corrupted / not working": "#CFFAFF",
            "Inactive": "#584477",
            "PageTables": "#0A50A1",
            "Page_Tables": "#0A50A1",
            "RAM_Free": "#E0F9D7",
            "Slab": "#806EB7",
            "Slab_Cache": "#E0752D",
            "Swap": "#BF1B00",
            "Swap_Cache": "#C15C17",
            "Swap_Free": "#2F575E",
            "Unused": "#EAB839"
          },
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_vmstat_nr_kernel_stack{node_name=~"$host"}[$interval]) or max_over_time(node_vmstat_nr_kernel_stack{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Total',
            step=240,
          )
      ),
      gridPos={
        "h": 8,
         "w": 12,
         "x": 0,
         "y": 54,
      }
    )//212 graph
    .addPanel(
      graphPanel.new(
        'Slab Pages',//title
        description='',
        fill=2,
        decimals=2,
        linewidth=2,
        datasource='Prometheus',
        pointradius=5,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        legend_sideWidth=350,
        maxPerRow=6,
        value_type='cumulative',
        labelY1='Pages',
        logBase1Y=2,
        minY1='0',
        aliasColors={
            "Apps": "#629E51",
            "Buffers": "#614D93",
            "Cache": "#6D1F62",
            "Cached": "#511749",
            "Committed": "#508642",
            "Free": "#0A437C",
            "Harware Corrupted - Amount of RAM that the kernel identified as corrupted / not working": "#CFFAFF",
            "Inactive": "#584477",
            "PageTables": "#0A50A1",
            "Page_Tables": "#0A50A1",
            "RAM_Free": "#E0F9D7",
            "Slab": "#806EB7",
            "Slab_Cache": "#E0752D",
            "Swap": "#BF1B00",
            "Swap_Cache": "#C15C17",
            "Swap_Free": "#2F575E",
            "Unused": "#EAB839"
          },
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_vmstat_nr_slab_reclaimable{node_name=~"$host"}[$interval]) or max_over_time(node_vmstat_nr_slab_reclaimable{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Reclaimable',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(node_vmstat_nr_slab_unreclaimable{node_name=~"$host"}[$interval]) or max_over_time(node_vmstat_nr_slab_unreclaimable{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Unreclaimable',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'rate(node_vmstat_slabs_scanned{node_name=~"$host"}[$interval]) or irate(node_vmstat_slabs_scanned{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Scanned',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(node_vmstat_drop_slab{node_name=~"$host"}[$interval]) or irate(node_vmstat_drop_slab{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Dropped',
          )
      ),
      gridPos={
        "h": 8,
         "w": 12,
         "x": 12,
         "y": 54,
      }
    )//188 graph
    ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 13,
    },
    style=null,
)//236 row
.addPanel(
    row.new(
      title='Pages per Zone',
      collapse=true,
    )
    .addPanel(
      graphPanel.new(
        'Allocations',//title
        fill=2,
        decimals=2,
        linewidth=2,
        datasource='Prometheus',
        pointradius=5,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        legend_sideWidth=350,
        maxPerRow=6,
        value_type='cumulative',
        labelY1='Pages',
        minY1='0',
        aliasColors={
            "Apps": "#629E51",
            "Buffers": "#614D93",
            "Cache": "#6D1F62",
            "Cached": "#511749",
            "Committed": "#508642",
            "Free": "#0A437C",
            "Harware Corrupted - Amount of RAM that the kernel identified as corrupted / not working": "#CFFAFF",
            "Inactive": "#584477",
            "PageTables": "#0A50A1",
            "Page_Tables": "#0A50A1",
            "RAM_Free": "#E0F9D7",
            "Slab": "#806EB7",
            "Slab_Cache": "#E0752D",
            "Swap": "#BF1B00",
            "Swap_Cache": "#C15C17",
            "Swap_Free": "#2F575E",
            "Unused": "#EAB839"
          },
      )
      .addTarget(
          prometheus.target(
            'rate(node_vmstat_pgalloc_dma{node_name=~"$host"}[$interval]) or irate(node_vmstat_pgalloc_dma{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Dma',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'rate(node_vmstat_pgalloc_dma32{node_name=~\"$host\"}[$interval]) or irate(node_vmstat_pgalloc_dma32{node_name=~\"$host\"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Dma32',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'rate(node_vmstat_pgalloc_normal{node_name=~\"$host\"}[$interval]) or irate(node_vmstat_pgalloc_normal{node_name=~\"$host\"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Normal',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'rate(node_vmstat_pgalloc_movable{node_name=~"$host"}[$interval]) or irate(node_vmstat_pgalloc_movable{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Movable',
          )
      ),
      gridPos={
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 15,
      }
    )//201 graph
    .addPanel(
      graphPanel.new(
        'Refill',//title
        fill=2,
        decimals=2,
        linewidth=2,
        datasource='Prometheus',
        pointradius=5,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        legend_sideWidth=350,
        maxPerRow=6,
        value_type='cumulative',
        labelY1='Pages',
        minY1='0',
        aliasColors={
            "Apps": "#629E51",
            "Buffers": "#614D93",
            "Cache": "#6D1F62",
            "Cached": "#511749",
            "Committed": "#508642",
            "Free": "#0A437C",
            "Harware Corrupted - Amount of RAM that the kernel identified as corrupted / not working": "#CFFAFF",
            "Inactive": "#584477",
            "PageTables": "#0A50A1",
            "Page_Tables": "#0A50A1",
            "RAM_Free": "#E0F9D7",
            "Slab": "#806EB7",
            "Slab_Cache": "#E0752D",
            "Swap": "#BF1B00",
            "Swap_Cache": "#C15C17",
            "Swap_Free": "#2F575E",
            "Unused": "#EAB839"
          },
      )
      .addTarget(
          prometheus.target(
            'rate(node_vmstat_pgrefill_dma{node_name=~"$host"}[$interval]) or irate(node_vmstat_pgrefill_dma{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Dma',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'rate(node_vmstat_pgrefill_dma32{node_name=~"$host"}[$interval]) or irate(node_vmstat_pgrefill_dma32{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Dma32',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'rate(node_vmstat_pgrefill_normal{node_name=~"$host"}[$interval]) or irate(node_vmstat_pgrefill_normal{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Normal',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'rate(node_vmstat_pgrefill_movable{node_name=~"$host"}[$interval]) or irate(node_vmstat_pgrefill_movable{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Movable',
          )
      ),
      gridPos={
        "h": 8,
        "w": 12,
        "x": 12,
        "y": 15,
      }
    )//256 graph
    .addPanel(
      graphPanel.new(
        'Direct Scan',//title
        fill=2,
        decimals=2,
        linewidth=2,
        datasource='Prometheus',
        pointradius=5,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        legend_sideWidth=350,
        maxPerRow=6,
        value_type='cumulative',
        labelY1='Pages',
        minY1='0',
        aliasColors={
            "Apps": "#629E51",
            "Buffers": "#614D93",
            "Cache": "#6D1F62",
            "Cached": "#511749",
            "Committed": "#508642",
            "Free": "#0A437C",
            "Harware Corrupted - Amount of RAM that the kernel identified as corrupted / not working": "#CFFAFF",
            "Inactive": "#584477",
            "PageTables": "#0A50A1",
            "Page_Tables": "#0A50A1",
            "RAM_Free": "#E0F9D7",
            "Slab": "#806EB7",
            "Slab_Cache": "#E0752D",
            "Swap": "#BF1B00",
            "Swap_Cache": "#C15C17",
            "Swap_Free": "#2F575E",
            "Unused": "#EAB839"
          },
      )
      .addTarget(
          prometheus.target(
            'rate(node_vmstat_pgscan_direct_dma{node_name=~\"$host\"}[$interval]) or irate(node_vmstat_pgscan_direct_dma{node_name=~\"$host\"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Dma',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'rate(node_vmstat_pgscan_direct_dma32{node_name=~"$host"}[$interval]) or irate(node_vmstat_pgscan_direct_dma32{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Dma32',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'rate(node_vmstat_pgscan_direct_normal{node_name=~"$host"}[$interval]) or irate(node_vmstat_pgscan_direct_normal{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Normal',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'rate(node_vmstat_pgscan_direct_movable{node_name=~"$host"}[$interval]) or irate(node_vmstat_pgscan_direct_movable{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Movable',
          )
      ),
      gridPos={
          "h": 8,
          "w": 12,
          "x": 0,
          "y": 23,
      }
    )//257 graph
    .addPanel(
      graphPanel.new(
        'Kswapd Scan',//title
        fill=2,
        decimals=2,
        linewidth=2,
        datasource='Prometheus',
        pointradius=5,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        legend_sideWidth=350,
        maxPerRow=6,
        value_type='cumulative',
        labelY1='Pages',
        minY1='0',
        aliasColors={
            "Apps": "#629E51",
            "Buffers": "#614D93",
            "Cache": "#6D1F62",
            "Cached": "#511749",
            "Committed": "#508642",
            "Free": "#0A437C",
            "Harware Corrupted - Amount of RAM that the kernel identified as corrupted / not working": "#CFFAFF",
            "Inactive": "#584477",
            "PageTables": "#0A50A1",
            "Page_Tables": "#0A50A1",
            "RAM_Free": "#E0F9D7",
            "Slab": "#806EB7",
            "Slab_Cache": "#E0752D",
            "Swap": "#BF1B00",
            "Swap_Cache": "#C15C17",
            "Swap_Free": "#2F575E",
            "Unused": "#EAB839"
          },
      )
      .addTarget(
          prometheus.target(
            'rate(node_vmstat_pgscan_kswapd_dma{node_name=~"$host"}[$interval]) or irate(node_vmstat_pgscan_kswapd_dma{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Dma',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'rate(node_vmstat_pgscan_kswapd_dma32{node_name=~"$host"}[$interval]) or irate(node_vmstat_pgscan_kswapd_dma32{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Dma32',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'rate(node_vmstat_pgscan_kswapd_normal{node_name=~"$host"}[$interval]) or irate(node_vmstat_pgscan_kswapd_normal{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Normal',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'rate(node_vmstat_pgscan_kswapd_movable{node_name=~"$host"}[$interval]) or irate(node_vmstat_pgscan_kswapd_movable{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Movable',
          )
      ),
      gridPos={
          "h": 8,
          "w": 12,
          "x": 12,
          "y": 23,
      }
    )//258 graph
    .addPanel(
      graphPanel.new(
        'Steal Direct',//title
        fill=2,
        linewidth=2,
        datasource='Prometheus',
        pointradius=5,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        nullPointMode='null as zero',
        maxPerRow=6,
        labelY1='Pages',
        minY1='0',
      )
      .addTarget(
          prometheus.target(
            'rate(node_vmstat_pgsteal_direct_dma{node_name=~"$host"}[$interval]) or irate(node_vmstat_pgsteal_direct_dma{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Dma',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'rate(node_vmstat_pgsteal_direct_dma32{node_name=~"$host"}[$interval]) or irate(node_vmstat_pgsteal_direct_dma32{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Dma32',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'rate(node_vmstat_pgsteal_direct_normal{node_name=~"$host"}[$interval]) or irate(node_vmstat_pgsteal_direct_normal{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Normal',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'rate(node_vmstat_pgsteal_direct_movable{node_name=~"$host"}[$interval]) or irate(node_vmstat_pgsteal_direct_movable{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Movable',
          )
      ),
      gridPos={
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 31,
      }
    )//252 graph
    .addPanel(
      graphPanel.new(
        'Steal Kswapd',//title
        fill=2,
        decimals=2,
        linewidth=2,
        datasource='Prometheus',
        pointradius=5,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        legend_sideWidth=350,
        maxPerRow=6,
        value_type='cumulative',
        labelY1='Pages',
        minY1='0',
        aliasColors={
            "Apps": "#629E51",
            "Buffers": "#614D93",
            "Cache": "#6D1F62",
            "Cached": "#511749",
            "Committed": "#508642",
            "Free": "#0A437C",
            "Harware Corrupted - Amount of RAM that the kernel identified as corrupted / not working": "#CFFAFF",
            "Inactive": "#584477",
            "PageTables": "#0A50A1",
            "Page_Tables": "#0A50A1",
            "RAM_Free": "#E0F9D7",
            "Slab": "#806EB7",
            "Slab_Cache": "#E0752D",
            "Swap": "#BF1B00",
            "Swap_Cache": "#C15C17",
            "Swap_Free": "#2F575E",
            "Unused": "#EAB839"
          },
      )
      .addTarget(
          prometheus.target(
            'rate(node_vmstat_pgsteal_kswapd_dma{node_name=~"$host"}[$interval]) or irate(node_vmstat_pgsteal_kswapd_dma{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Dma',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'rate(node_vmstat_pgsteal_kswapd_dma32{node_name=~"$host"}[$interval]) or irate(node_vmstat_pgsteal_kswapd_dma32{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Dma32',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'rate(node_vmstat_pgsteal_kswapd_normal{node_name=~"$host"}[$interval]) or irate(node_vmstat_pgsteal_kswapd_normal{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Normal',
            step=240,
          )
      )
      .addTarget(
          prometheus.target(
            'rate(node_vmstat_pgsteal_kswapd_movable{node_name=~"$host"}[$interval]) or irate(node_vmstat_pgsteal_kswapd_movable{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Movable',
          )
      ),
      gridPos={
          "h": 8,
          "w": 12,
          "x": 12,
          "y": 31,
      }
    )//259 graph
    ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 14,
    },
    style=null,
)//250 row
