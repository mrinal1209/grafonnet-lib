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
  'NUMA Overview',
  time_from='now-12h',
  editable=false,
  refresh= '1m',
  graphTooltip='shared_crosshair',
  schemaVersion=18,
  version=4,
  tags=['OS','Percona'],
  iteration=1560951716421,
  uid='8gx8yeMik',
  timepicker = timepicker.new(
    hidden = false,
    collapse= false,
    enable= true,
    notice=false,
    now= true,
    status='Stable',
  ),
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
  'label_values(node_memory_numa_MemTotal, node_name)',
  label='Host',
  refresh='load',
  sort=1,
  allFormat='glob',
  multiFormat='regex values',
  multi=false,
  skipUrlSync=false,
  definition='label_values(node_memory_numa_MemTotal, node_name)',
  tagsQuery='up',
  tagValuesQuery='instance',
  refresh_on_load=false,
  ),
)
.addTemplate(
  template.new(
  'mountpoint',
  'Prometheus',
  'label_values(node_filesystem_avail_bytes{node_name=~"$host", fstype!~"rootfs|selinuxfs|autofs|rpc_pipefs|tmpfs"}, mountpoint)',
  label='Mountpoint',
  refresh='load',
  sort=1,
  allFormat='wildcard',
  multiFormat='regex values',
  multi=false,
  skipUrlSync=false,
  includeAll=true,
  tagsQuery='up',
  tagValuesQuery='instance',
  refresh_on_load=false,
  hide=2,
  ),
)
.addTemplate(
  template.new(
  'node',
  'Prometheus',
  'label_values(node_memory_numa_numa_hit_total,node)',
  label='Node',
  refresh='load',
  sort=0,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  refresh_on_load=false,
  hide=2,
  ),
)
.addTemplate(
  template.new(
  'zone',
  'Prometheus',
  'label_values(node_buddyinfo_blocks{node_name=~"$host"}, zone)',
  definition='label_values(node_buddyinfo_blocks{node_name=~"$host"}, zone)',
  label='Zone',
  refresh='load',
  sort=0,
  multi=true,
  skipUrlSync=false,
  includeAll=true,
  hide=2,
  ),
)
.addPanel(
    row.new(
      title='Total',
    ),
    gridPos={
       "h": 1,
        "w": 24,
        "x": 0,
        "y": 0,
    },
    style=null,
)//35 row
.addPanel(
  graphPanel.new(
    'Memory Usage',//title
    fill=2,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=1,
    paceLength=10,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    legend_sortDesc=true,
    legend_sort='avg',
    editable=true,
    formatY1='bytes',
    formatY2='short',
    aliasColors={
      "Free": "#1f78c1",
      "Used": "#962d82",
    },
    stack=true,
    minY1=0,
   )
  .addSeriesOverride(
     {
        "alias": "Total",
        "color": "#bf1b00",
        "fill": 0,
        "points": true,
        "stack": false,
        "zindex": 3
      }
    )
  .addSeriesOverride(
    {
      "alias": "Free",
      "zindex": -1
    }
    )
  .addSeriesOverride(
    {
      "alias": "Used",
      "zindex": -2
    }
    )
  .addTarget(
      prometheus.target(
        'sum by (node) (node_memory_numa_MemTotal{node_name=~"$host"})',
        refId='C',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Total'
      )
   )
  .addTarget(
      prometheus.target(
        'sum by (node) (node_memory_numa_MemFree{node_name=~"$host"})',
        refId='A',
        interval='$interval',
        legendFormat='Free',
        intervalFactor=1,
      )
      )
  .addTarget(
          prometheus.target(
            'sum by (node) (node_memory_numa_MemUsed{node_name=~"$host"})',
            refId='B',
            interval='$interval',
            legendFormat='Used',
            intervalFactor=1,
          )
   ),
  gridPos={
      "h": 7,
      "w": 12,
      "x": 0,
      "y": 1,
   },
  style=null,
)//22 graph
.addPanel(
  graphPanel.new(
    'Free Memory Percent',//title
    fill=2,
    bars=true,
    lines=false,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    legend_sortDesc=true,
    legend_sort='avg',
    editable=true,
    formatY1='percent',
    formatY2='short',
    aliasColors={
      "Free": "#1f78c1",
      "Used": "#962d82",
     },
    stack=true,
    minY1='0',
   )
  .addTarget(
      prometheus.target(
        'sum by (node) (node_memory_numa_MemFree{node_name=~\"$host\"}) * 100 /\nsum by (node) (node_memory_numa_MemTotal{node_name=~\"$host\"})',
        refId='A',
        interval='$interval',
        legendFormat='Free',
        intervalFactor=1,
      )
      )
  .addTarget(
          prometheus.target(
            'sum by (node) (node_memory_numa_MemUsed{node_name=~\"$host\"}) * 100 /\nsum by (node) (node_memory_numa_MemTotal{node_name=~\"$host\"})',
            refId='B',
            interval='$interval',
            legendFormat='Used',
            intervalFactor=1,
            hide=true,
          )
   ),
  gridPos={
      "h": 7,
      "w": 12,
      "x": 12,
      "y": 1,
   },
  style=null,
)//23 graph
.addPanel(
  graphPanel.new(
    'NUMA Memory Usage Types',//title
    description='**Dirty** Memory waiting to be written back to disk\n\n**Bounce** Memory used for block device bounce buffers\n\n**Mapped** Files which have been mmaped, such as libraries\n\n**KernelStack** The memory the kernel stack uses. This is not reclaimable.',
    fill=0,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    legend_sortDesc=true,
    legend_sort='avg',
    legend_rightSide=true,
    editable=true,
    format='bytes',
    maxPerRow=2,
    aliasColors={
      "Free (device /dev/xvda1, ext4)": "#82B5D8",
      "Used (device /dev/xvda1, ext4)": "#BA43A9",
      },
    minY1=0,
   )
  .addTarget(
      prometheus.target(
        'sum(node_memory_numa_Inactive{node_name=~"$host"})',
        refId='A',
        interval='$interval',
        legendFormat='Inactive',
        intervalFactor=1,
      )
      )
  .addTarget(
          prometheus.target(
            'sum(node_memory_numa_Active{node_name=~"$host"})',
            refId='B',
            interval='$interval',
            legendFormat='Active',
            intervalFactor=1,
            hide=false,
            calculatedInterval='2m',
            step=300,
          )
          )
  .addTarget(
        prometheus.target(
          'sum(node_memory_numa_Dirty{node_name=~"$host"})',
           refId='C',
           interval='$interval',
           legendFormat='Dirty',
           intervalFactor=1,
          )
      )
  .addTarget(
         prometheus.target(
           'sum(node_memory_numa_Bounce{node_name=~"$host"})',
            refId='D',
            interval='$interval',
            legendFormat='Bounce',
            intervalFactor=1,
           )
       )
  .addTarget(
           prometheus.target(
             'sum(node_memory_numa_Mapped{node_name=~"$host"})',
              refId='E',
              interval='$interval',
              legendFormat='Mapped',
              intervalFactor=1,
             )
         )
  .addTarget(
      prometheus.target(
       'sum(node_memory_numa_KernelStack{node_name=~"$host"})',
       refId='F',
       interval='$interval',
       legendFormat='KernelStack',
       intervalFactor=1,
      )
    ),
  gridPos={
      "h": 7,
      "w": 24,
      "x": 0,
      "y": 8,
   },
  style=null,
)//9 graph
.addPanel(
  graphPanel.new(
    'NUMA Allocation Hits',//title
    description='Memory successfully allocated on this node as intended.',
    fill=2,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    legend_sortDesc=true,
    legend_sort='avg',
    editable=true,
    formatY1='ops',
    formatY2='short',
    stack=true,
   )
  .addSeriesOverride(
    {
      "alias": "Total",
      "color": "#bf1b00",
      "fill": 0,
      "stack": false
    }
    )
  .addTarget(
      prometheus.target(
        'rate(node_memory_numa_numa_hit_total{node_name=~"$host"}[$interval]) or
        irate(node_memory_numa_numa_hit_total{node_name=~"$host"}[5m])',
        refId='A',
        interval='$interval',
        legendFormat='Node $node',
        intervalFactor=1,
        hide=false,
      )
      )
  .addTarget(
          prometheus.target(
            'sum(rate(node_memory_numa_numa_hit_total{node_name=~"$host"}[$interval])) or
            sum(irate(node_memory_numa_numa_hit_total{node_name=~"$host"}[5m]))',
            refId='B',
            interval='$interval',
            legendFormat='Total',
            intervalFactor=1,
          )
    ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 15,
   },
  style=null,
)//27 graph
.addPanel(
  graphPanel.new(
    'NUMA Allocation Missed',//title
    description='**Memory missed** is allocated on a node despite the process preferring some different node.\n\n**Memory foreign** is intended for a node, but actually allocated on some different node.',
    fill=2,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    legend_sortDesc=true,
    legend_sort='avg',
    editable=true,
    formatY1='ops',
    formatY2='percent',
    min=0,
   )
  .addSeriesOverride(
      {
        "alias": "Missed ratio Node 0",
        "pointradius": 1,
        "points": true,
        "yaxis": 2
      }
    )
  .addSeriesOverride(
    {
     "alias": "Foreign ratio Node 0",
     "pointradius": 1,
     "points": true,
     "yaxis": 2,
     }
   )
  .addSeriesOverride(
    {
    "alias": "Total Missed",
    "color": "#bf1b00"
    }
    )
  .addSeriesOverride(
     {
      "alias": "Total Missed Ratio",
      "pointradius": 1,
      "points": true,
      "yaxis": 2
      }
    )
  .addTarget(
      prometheus.target(
        'rate(node_memory_numa_numa_miss_total{node_name=~"$host"}[$interval]) or
        irate(node_memory_numa_numa_miss_total{node_name=~"$host"}[5m])',
        refId='A',
        interval='$interval',
        legendFormat='Missed Node $node',
        intervalFactor=1,
        hide=false,
      )
      )
  .addTarget(
          prometheus.target(
            'rate(node_memory_numa_numa_foreign_total{node_name=~"$host"}[$interval]) or
            irate(node_memory_numa_numa_foreign_total{node_name=~"$host"}[5m])',
            refId='B',
            interval='$interval',
            legendFormat='Foreign Node $node',
            intervalFactor=1,
            hide=true,
          )
    )
  .addTarget(
        prometheus.target(
          'rate(node_memory_numa_numa_miss_total{node_name=~"$host"}[$interval]) or
          irate(node_memory_numa_numa_miss_total{node_name=~"$host"}[5m]) * 100 /
          (rate(node_memory_numa_numa_hit_total{node_name=~"$host"}[$interval]) or
          irate(node_memory_numa_numa_hit_total{node_name=~"$host"}[5m]) +
          rate(node_memory_numa_numa_miss_total{node_name=~"$host"}[$interval]) or
          irate(node_memory_numa_numa_miss_total{node_name=~"$host"}[5m]))',
          refId='C',
          interval='$interval',
          legendFormat='Missed ratio Node $node',
          intervalFactor=1,
        )
        )
  .addTarget(
            prometheus.target(
              'rate(node_memory_numa_numa_foreign_total{node_name=~"$host"}[$interval]) or
              irate(node_memory_numa_numa_foreign_total{node_name=~"$host"}[5m]) * 100 /
              (rate(node_memory_numa_numa_hit_total{node_name=~"$host"}[$interval]) or
              irate(node_memory_numa_numa_hit_total{node_name=~"$host"}[5m]) +
              rate(node_memory_numa_numa_foreign_total{node_name=~"$host"}[$interval]) or
              irate(node_memory_numa_numa_foreign_total{node_name=~"$host"}[5m]))',
              refId='D',
              interval='$interval',
              legendFormat='Foreign ratio Node $node',
              intervalFactor=1,
              hide=true,
            )
      )
  .addTarget(
          prometheus.target(
            'sum(rate(node_memory_numa_numa_miss_total{node_name=~"$host"}[$interval])) or
            sum(irate(node_memory_numa_numa_miss_total{node_name=~"$host"}[5m]))',
            refId='E',
            interval='$interval',
            legendFormat='Total Missed',
            intervalFactor=1,
          )
          )
  .addTarget(
              prometheus.target(
                'sum(rate(node_memory_numa_numa_miss_total{node_name=~"$host"}[$interval])) or
                sum(irate(node_memory_numa_numa_miss_total{node_name=~"$host"}[5m])) * 100 /
                sum((rate(node_memory_numa_numa_hit_total{node_name=~"$host"}[$interval])) or
                sum(irate(node_memory_numa_numa_hit_total{node_name=~"$host"}[5m])) +
                sum(rate(node_memory_numa_numa_miss_total{node_name=~"$host"}[$interval])) or
                sum(irate(node_memory_numa_numa_miss_total{node_name=~"$host"}[5m])))',
                refId='F',
                interval='$interval',
                legendFormat='Total Missed Ratio',
                intervalFactor=1,
              )
        ),
  gridPos={
      "h": 7,
      "w": 12,
      "x": 12,
      "y": 15,
   },
  style=null,
)//29 graph
.addPanel(
  graphPanel.new(
    'Anonymous Memory',//title
    description='**Active anonymous memory** that has been used more recently and usually not swapped out.\n\n**Inactive anonymous memory** that has not been used recently and can be swapped out.',
    fill=2,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    legend_sortDesc=true,
    legend_sort='avg',
    editable=true,
    formatY1='bytes',
    formatY2='short',
    stack=true,
   )
  .addTarget(
      prometheus.target(
        'sum(avg_over_time(node_memory_numa_Active_anon{node_name=~"$host"}[$interval]))',
        refId='A',
        interval='$interval',
        legendFormat='Active',
        intervalFactor=1,
      )
      )
  .addTarget(
          prometheus.target(
            'sum(avg_over_time(node_memory_numa_Inactive_anon{node_name=~"$host"}[$interval]))',
            refId='B',
            interval='$interval',
            legendFormat='Inactive',
            intervalFactor=1,
          )
        ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 22,
   },
  style=null,
)//16 graph
.addPanel(
  graphPanel.new(
    'NUMA File (PageCache)',//title
    description='**Active(file)** Pagecache memory that has been used more recently and usually not reclaimed until needed\n\n**Inactive(file)** Pagecache memory that can be reclaimed without huge performance impact',
    fill=2,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    legend_sortDesc=true,
    legend_sort='avg',
    editable=true,
    formatY1='bytes',
    formatY2='short',
    stack=true,
    minY1=0,
   )
  .addTarget(
      prometheus.target(
        'sum(avg_over_time(node_memory_numa_Active_file{node_name=~"$host"}[$interval]))',
        refId='A',
        interval='$interval',
        legendFormat='Active',
        intervalFactor=1,
      )
      )
  .addTarget(
          prometheus.target(
            'sum(avg_over_time(node_memory_numa_Inactive_file{node_name=~"$host"}[$interval]))',
            refId='B',
            interval='$interval',
            legendFormat='Inactive',
            intervalFactor=1,
          )
        ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 12,
    "y": 22,
   },
  style=null,
)//18 graph
.addPanel(
  graphPanel.new(
    'Shared Memory',//title
    description='**Shmem** Total used shared memory (shared between several processes, thus including RAM disks, SYS-V-IPC and BSD like SHMEM)',
    fill=2,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    legend_sortDesc=true,
    legend_sort='avg',
    editable=true,
    formatY1='bytes',
    formatY2='short',
    minY1=0,
   )
  .addTarget(
      prometheus.target(
        'sum by (node) (node_memory_numa_Shmem{node_name=~"$host"})',
        refId='A',
        interval='$interval',
        legendFormat='Total',
        intervalFactor=1,
      )
      )
  .addTarget(
          prometheus.target(
            'sum by (node) (node_memory_numa_ShmemHugePages{node_name=~"$host"})',
            refId='B',
            interval='$interval',
            legendFormat='HugePages',
            intervalFactor=1,
          )
    )
  .addTarget(
            prometheus.target(
              'sum by (node) (node_memory_numa_ShmemPmdMapped{node_name=~"$host"})',
              refId='C',
              interval='$interval',
              legendFormat='PmdMapped',
              intervalFactor=1,
            )
        ),
  gridPos={
      "h": 7,
      "w": 12,
      "x": 0,
      "y": 29,
   },
  style=null,
)//41 graph
.addPanel(
  graphPanel.new(
    'HugePages Statistic',//title
    description='**Total** Number of hugepages being allocated by the kernel (Defined with vm.nr_hugepages)\n\n**Free** The number of hugepages not being allocated by a process\n\n**Surp**  The number of hugepages in the pool above the value in vm.nr_hugepages. The maximum number of surplus hugepages is controlled by vm.nr_overcommit_hugepages.',
    fill=2,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    legend_sortDesc=true,
    legend_sort='avg',
    editable=true,
    minY1=0,
   )
  .addTarget(
      prometheus.target(
        'sum by (node) (node_memory_numa_HugePages_Total{node_name=~"$host"})',
        refId='A',
        interval='$interval',
        legendFormat='Total',
        intervalFactor=1,
      )
      )
  .addTarget(
          prometheus.target(
            'sum by (node) (node_memory_numa_HugePages_Free{node_name=~"$host"})',
            refId='B',
            interval='$interval',
            legendFormat='Free',
            intervalFactor=1,
          )
    )
  .addTarget(
            prometheus.target(
              'sum by (node) (node_memory_numa_HugePages_Surp{node_name=~"$host"})',
              refId='C',
              interval='$interval',
              legendFormat='Surplus',
              intervalFactor=1,
            )
        ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 12,
    "y": 29,
   },
  style=null,
)//37 graph
.addPanel(
  graphPanel.new(
    'Local Processes',//title
    description='Memory allocated on a node while a process was running on it.',
    fill=2,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    legend_sortDesc=true,
    legend_sort='avg',
    editable=true,
    formatY1='ops',
    formatY2='percent',
    stack=true,
    min='0',
   )
  .addSeriesOverride(
    {
      "alias": "Total",
      "color": "#bf1b00",
      "fill": 0,
      "stack": false
    }
    )
  .addSeriesOverride(
    {
        "alias": "Total local processes rate",
        "lines": false,
        "points": true,
        "yaxis": 2
    }
   )
  .addTarget(
      prometheus.target(
        'rate(node_memory_numa_local_node_total{node_name=~"$host"}[$interval]) or
        irate(node_memory_numa_local_node_total{node_name=~"$host"}[$interval])',
        refId='A',
        interval='$interval',
        legendFormat='Node $node',
        intervalFactor=1,
        hide=false,
       )
    )
  .addTarget(
          prometheus.target(
            'sum(rate(node_memory_numa_local_node_total{node_name=~"$host"}[$interval])) or
            sum(irate(node_memory_numa_local_node_total{node_name=~"$host"}[$interval]))',
            refId='B',
            interval='$interval',
            legendFormat='Total',
            intervalFactor=1,
            hide=false,
          )
        ),
  gridPos={
      "h": 7,
      "w": 12,
      "x": 0,
      "y": 36,
   },
  style=null,
)//46 graph
.addPanel(
  graphPanel.new(
    'Remote Processes',//title
    description='Memory allocated on a node while a process was running on some other node.',
    fill=2,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    legend_sortDesc=true,
    legend_sort='avg',
    editable=true,
    formatY1='ops',
    formatY2='percent',
    min=0,
   )
  .addSeriesOverride(
     {
        "alias": "Total",
        "color": "#bf1b00",
        "fill": 0,
        "stack": false
      }
    )
  .addSeriesOverride(
     {
        "alias": "Total remote processes rate",
        "lines": false,
        "points": true,
        "yaxis": 2
      }
   )
  .addTarget(
      prometheus.target(
        'rate(node_memory_numa_other_node_total{node_name=~"$host", node="$node"}[$interval]) or
        irate(node_memory_numa_other_node_total{node_name=~"$host", node="$node"}[5m])',
        refId='A',
        interval='$interval',
        legendFormat='Node $node',
        intervalFactor=1,
       )
    )
  .addTarget(
          prometheus.target(
            'sum(rate(node_memory_numa_other_node_total{node_name=~"$host", node="$node"}[$interval])) or
            sum(irate(node_memory_numa_other_node_total{node_name=~"$host", node="$node"}[5m]))',
            refId='B',
            interval='$interval',
            legendFormat='Total',
            intervalFactor=1,
          )
        )
  .addTarget(
            prometheus.target(
              'sum(rate(node_memory_numa_other_node_total{node_name=~"$host", node="$node"}[$interval])) or
              sum(irate(node_memory_numa_other_node_total{node_name=~"$host", node="$node"}[5m])) * 100 /
              (sum(rate(node_memory_numa_other_node_total{node_name=~"$host", node="$node"}[$interval])) or
              sum(irate(node_memory_numa_other_node_total{node_name=~"$host", node="$node"}[5m])) +
              sum(rate(node_memory_numa_local_node_total{node_name=~"$host"}[$interval])) or
              sum(irate(node_memory_numa_local_node_total{node_name=~"$host"}[$interval])))',
              refId='C',
              interval='$interval',
              legendFormat='Total remote processes rate',
              intervalFactor=1,
             )
          ),
  gridPos={
      "h": 7,
      "w": 12,
      "x": 12,
      "y": 36,
   },
  style=null,
)//47 graph
.addPanel(
  graphPanel.new(
    'Slab Memory',//title
    description="**Slab** allocation is a memory management mechanism intended for the efficient memory allocation of kernel objects.\n\n**SReclaimable** The part of the Slab that might be reclaimed (such as caches).\n\n**SUnreclaim** The part of the Slab that can't be reclaimed under memory pressure",
    fill=2,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    legend_sortDesc=true,
    legend_sort='avg',
    editable=true,
    formatY1='bytes',
    formatY2='short',
    stack=true,
    aliasColors={
        "Total": "#bf1b00"
      },
   )
  .addSeriesOverride(
    {
       "alias": "Total",
       "color": "#bf1b00",
       "points": true,
       "stack": false,
     }
   )
  .addTarget(
      prometheus.target(
        'sum(avg_over_time(node_memory_numa_Slab{node_name=~"$host"}[$interval]))',
        refId='A',
        interval='$interval',
        legendFormat='Total',
        intervalFactor=1,
       )
    )
  .addTarget(
          prometheus.target(
            'sum(avg_over_time(node_memory_numa_SReclaimable{node_name=~"$host"}[$interval]))',
            refId='B',
            interval='$interval',
            legendFormat='Reclaimable',
            intervalFactor=1,
          )
        )
  .addTarget(
            prometheus.target(
              'sum(avg_over_time(node_memory_numa_SUnreclaim{node_name=~"$host"}[$interval]))',
              refId='C',
              interval='$interval',
              legendFormat='Unreclaim',
              intervalFactor=1,
             )
          ),
  gridPos={
   "h": 7,
   "w": 12,
   "x": 0,
   "y": 43,
   },
  style=null,
)//39 graph
.addPanel(
    row.new(
      title='Node $node',
      collapse=true,
      repeat='node',
    )
    .addPanel(
      graphPanel.new(
        'Node $node - Memory Usage',//title
        fill=2,
        linewidth=2,
        decimals=2,
        datasource='Prometheus',
        pointradius=5,
        paceLength=10,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sortDesc=true,
        legend_sort='avg',
        editable=true,
        formatY1='bytes',
        formatY2='short',
        aliasColors={
          "Free": "#1f78c1",
          "Used": "#962d82",
        },
        stack=true,
        minY1='0',
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
            'avg_over_time(node_memory_numa_MemTotal{node_name=~"$host", node="$node"}[$interval])',
            refId='C',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Total'
          )
       )
      .addTarget(
          prometheus.target(
            'avg_over_time(node_memory_numa_MemFree{node_name=~"$host", node="$node"}[$interval])',
            refId='A',
            interval='$interval',
            legendFormat='Free',
            intervalFactor=1,
          )
          )
      .addTarget(
              prometheus.target(
                'avg_over_time(node_memory_numa_MemUsed{node_name=~"$host", node="$node"}[$interval])',
                refId='B',
                interval='$interval',
                legendFormat='Used',
                intervalFactor=1,
              )
       ),
      gridPos={
       "h": 7,
        "w": 12,
        "x": 0,
        "y": 2,
       }
    )//25 graph
    .addPanel(
      graphPanel.new(
        'Node $node - Free Memory Percent',//title
        fill=2,
        linewidth=2,
        decimals=2,
        datasource='Prometheus',
        pointradius=5,
        paceLength=10,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sortDesc=true,
        legend_sort='avg',
        editable=true,
        formatY1='percent',
        formatY2='short',
        aliasColors={
          "Free": "#1f78c1",
          "Used": "#962d82",
         },
        stack=true,
       )
      .addTarget(
          prometheus.target(
            '(node_memory_numa_MemFree{node_name=~"$host", node="$node"}) * 100 /
            (node_memory_numa_MemTotal{node_name=~"$host", node="$node"})',
            refId='A',
            interval='$interval',
            legendFormat='Free',
            intervalFactor=1,
          )
          )
      .addTarget(
              prometheus.target(
                '(node_memory_numa_MemUsed{node_name=~"$host", node="$node"}) * 100 /
                (node_memory_numa_MemTotal{node_name=~"$host", node="$node"})',
                refId='B',
                interval='$interval',
                legendFormat='Used',
                intervalFactor=1,
                hide=true,
              )
       ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 12,
        "y": 2,
       }
    )//24 graph
    .addPanel(
      graphPanel.new(
        'Node $node - NUMA Memory Usage Types',//title
        description='**Dirty** Memory waiting to be written back to disk\n\n**Bounce** Memory used for block device bounce buffers\n\n**Mapped** Files which have been mmaped, such as libraries\n\n**KernelStack** The memory the kernel stack uses. This is not reclaimable.',
        fill=0,
        linewidth=2,
        decimals=2,
        datasource='Prometheus',
        pointradius=5,
        paceLength=10,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sortDesc=true,
        legend_sort='avg',
        legend_rightSide=true,
        editable=true,
        format='bytes',
        maxPerRow=2,
        aliasColors={
          "Free (device /dev/xvda1, ext4)": "#82B5D8",
          "Used (device /dev/xvda1, ext4)": "#BA43A9",
         },
         minY1=0,
       )
      .addTarget(
          prometheus.target(
            'avg_over_time(node_memory_numa_Inactive{node_name=~"$host"}[$interval])',
            refId='A',
            interval='$interval',
            legendFormat='Inactive',
            intervalFactor=1,
          )
          )
      .addTarget(
              prometheus.target(
                'avg_over_time(node_memory_numa_Active{node_name=~"$host"}[$interval])',
                refId='B',
                interval='$interval',
                legendFormat='Active',
                intervalFactor=1,
                hide=false,
                calculatedInterval='2m',
                step=300,
              )
              )
      .addTarget(
            prometheus.target(
              'avg_over_time(node_memory_numa_Dirty{node_name=~"$host"}[$interval])',
               refId='C',
               interval='$interval',
               legendFormat='Dirty',
               intervalFactor=1,
              )
          )
      .addTarget(
             prometheus.target(
               'avg_over_time(node_memory_numa_Bounce{node_name=~"$host"}[$interval])',
                refId='D',
                interval='$interval',
                legendFormat='Bounce',
                intervalFactor=1,
               )
           )
      .addTarget(
               prometheus.target(
                 'avg_over_time(node_memory_numa_Mapped{node_name=~"$host"}[$interval])',
                  refId='E',
                  interval='$interval',
                  legendFormat='Mapped',
                  intervalFactor=1,
                 )
             )
      .addTarget(
          prometheus.target(
           'avg_over_time(node_memory_numa_KernelStack{node_name=~"$host"}[$interval])',
           refId='F',
           interval='$interval',
           legendFormat='KernelStack',
           intervalFactor=1,
          )
        ),
      gridPos={
        "h": 7,
        "w": 24,
        "x": 0,
        "y": 9,
       }
    )//44 graph
    .addPanel(
      graphPanel.new(
        'Node $node - NUMA Allocation Hits',//title
        description='Memory successfully allocated on this node as intended.',
        fill=2,
        linewidth=2,
        decimals=2,
        datasource='Prometheus',
        pointradius=5,
        paceLength=10,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sortDesc=true,
        legend_sort='avg',
        editable=true,
        formatY1='ops',
        formatY2='short',
        stack=true,
       )
      .addSeriesOverride(
        {
          "alias": "Total",
          "color": "#bf1b00",
          "fill": 0,
          "stack": false
        }
        )
      .addTarget(
          prometheus.target(
            'rate(node_memory_numa_numa_hit_total{node_name=~"$host", node="$node"}[$interval]) or
            irate(node_memory_numa_numa_hit_total{node_name=~"$host", node="$node"}[5m])',
            refId='A',
            interval='$interval',
            legendFormat='Hit Total',
            intervalFactor=1,
            hide=false,
          )
        ),
      gridPos={
          "h": 7,
          "w": 12,
          "x": 0,
          "y": 16,
       }
    )//42 graph
    .addPanel(
      graphPanel.new(
        'Node $node - NUMA Allocation Missed/Foreign',//title
        description='**Memory missed** is allocated on a node despite the process preferring some different node.\n\n**Memory foreign** is intended for a node, but actually allocated on some different node.',
        fill=2,
        linewidth=2,
        decimals=2,
        datasource='Prometheus',
        pointradius=5,
        paceLength=10,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sortDesc=true,
        legend_sort='avg',
        editable=true,
        formatY1='ops',
        formatY2='percent',
        min='0',
       )
      .addSeriesOverride(
         {
            "alias": "Missed ratio",
            "pointradius": 1,
            "points": true,
            "yaxis": 2
          }
        )
      .addTarget(
          prometheus.target(
            'rate(node_memory_numa_numa_miss_total{node_name=~"$host", node="$node"}[$interval]) or
            irate(node_memory_numa_numa_miss_total{node_name=~"$host", node="$node"}[5m])',
            refId='A',
            interval='$interval',
            legendFormat='Missed',
            intervalFactor=1,
          )
          )
      .addTarget(
              prometheus.target(
                'rate(node_memory_numa_numa_miss_total{node_name=~"$host", node="$node"}[$interval]) or
                irate(node_memory_numa_numa_miss_total{node_name=~"$host", node="$node"}[5m]) * 100 /
                (rate(node_memory_numa_numa_hit_total{node_name=~"$host", node="$node"}[$interval]) or
                irate(node_memory_numa_numa_hit_total{node_name=~"$host", node="$node"}[5m]) +
                rate(node_memory_numa_numa_miss_total{node_name=~"$host", node="$node"}[$interval]) or
                irate(node_memory_numa_numa_miss_total{node_name=~"$host", node="$node"}[5m]))',
                refId='C',
                interval='$interval',
                legendFormat='Missed ratio',
                intervalFactor=1,
              )
            ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 12,
        "y": 16,
       }
    )//43 graph
    .addPanel(
      graphPanel.new(
        'Node $node - Anonymous Memory',//title
        description='**Active** Anonymous memory that has been used more recently and usually not swapped out\n\n**Inactive** Anonymous memory that has not been used recently and can be swapped out',
        fill=2,
        linewidth=2,
        decimals=2,
        datasource='Prometheus',
        pointradius=5,
        paceLength=10,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sortDesc=true,
        legend_sort='avg',
        editable=true,
        formatY1='bytes',
        formatY2='short',
        stack=true,
       )
      .addTarget(
          prometheus.target(
            'avg_over_time(node_memory_numa_Active_anon{node_name=~"$host",node="$node"}[$interval])',
            refId='A',
            interval='$interval',
            legendFormat='Active',
            intervalFactor=1,
          )
          )
      .addTarget(
              prometheus.target(
                'avg_over_time(node_memory_numa_Inactive_anon{node_name=~"$host", node="$node"}[$interval])',
                refId='B',
                interval='$interval',
                legendFormat='Inactive',
                intervalFactor=1,
              )
            ),
      gridPos={
          "h": 7,
          "w": 12,
          "x": 0,
          "y": 23,
       }
    )//20 graph
    .addPanel(
      graphPanel.new(
        'Node $node - NUMA File (PageCache)',//title
        description='**Active(file)** Pagecache memory that has been used more recently and usually not reclaimed until needed\n\n**Inactive(file)** Pagecache memory that can be reclaimed without huge performance impact',
        fill=2,
        linewidth=2,
        decimals=2,
        datasource='Prometheus',
        pointradius=5,
        paceLength=10,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sortDesc=true,
        legend_sort='avg',
        editable=true,
        formatY1='bytes',
        formatY2='short',
       )
      .addTarget(
          prometheus.target(
            'avg_over_time(node_memory_numa_Active_file{node_name=~"$host", node="$node"}[$interval])',
            refId='A',
            interval='$interval',
            legendFormat='Active',
            intervalFactor=1,
          )
          )
      .addTarget(
              prometheus.target(
                'avg_over_time(node_memory_numa_Inactive_file{node_name=~"$host", node="$node"}[$interval])',
                refId='B',
                interval='$interval',
                legendFormat='Inactive',
                intervalFactor=1,
              )
            ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 12,
        "y": 23,
       }
    )//19 graph
    .addPanel(
      graphPanel.new(
        'Node $node - Shared Memory',//title
        description='**Shmem** Total used shared memory (shared between several processes, thus including RAM disks, SYS-V-IPC and BSD like SHMEM)',
        fill=2,
        linewidth=2,
        decimals=2,
        datasource='Prometheus',
        pointradius=5,
        paceLength=10,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sortDesc=true,
        legend_sort='avg',
        editable=true,
        formatY1='bytes',
        formatY2='short',
        minY1='0',
       )
      .addTarget(
          prometheus.target(
            'sum by (node) (node_memory_numa_Shmem{node_name=~"$host", node="$node"})',
            refId='A',
            interval='$interval',
            legendFormat='Total',
            intervalFactor=1,
          )
          )
      .addTarget(
              prometheus.target(
                'sum by (node) (node_memory_numa_ShmemHugePages{node_name=~"$host", node="$node"})',
                refId='B',
                interval='$interval',
                legendFormat='HugePages',
                intervalFactor=1,
              )
        )
      .addTarget(
                prometheus.target(
                  'sum by (node) (node_memory_numa_ShmemPmdMapped{node_name=~"$host", node="$node"})',
                  refId='C',
                  interval='$interval',
                  legendFormat='PmdMapped',
                  intervalFactor=1,
                )
            ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 0,
        "y": 30,
       }
    )//48 graph
    .addPanel(
      graphPanel.new(
        'Node $node - HugePages Statistic',//title
        description='**Total** Number of hugepages being allocated by the kernel (Defined with vm.nr_hugepages)\n\n**Free** The number of hugepages not being allocated by a process\n\n**Surp**  The number of hugepages in the pool above the value in vm.nr_hugepages. The maximum number of surplus hugepages is controlled by vm.nr_overcommit_hugepages.',
        fill=2,
        linewidth=2,
        decimals=2,
        datasource='Prometheus',
        pointradius=5,
        paceLength=10,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sortDesc=true,
        legend_sort='avg',
        editable=true,
        format='short',
        minY1='0',
       )
      .addTarget(
          prometheus.target(
            'sum by (node) (node_memory_numa_HugePages_Total{node_name=~"$host", node="$node"})',
            refId='A',
            interval='$interval',
            legendFormat='Total',
            intervalFactor=1,
          )
          )
      .addTarget(
              prometheus.target(
                'sum by (node) (node_memory_numa_HugePages_Free{node_name=~"$host", node="$node"})',
                refId='B',
                interval='$interval',
                legendFormat='Free',
                intervalFactor=1,
              )
        )
      .addTarget(
                prometheus.target(
                  'sum by (node) (node_memory_numa_HugePages_Surp{node_name=~"$host", node="$node"})',
                  refId='C',
                  interval='$interval',
                  legendFormat='Surplus',
                  intervalFactor=1,
                )
            ),
      gridPos={
          "h": 7,
          "w": 12,
          "x": 12,
          "y": 30,
       }
    )//49 graph
    .addPanel(
      graphPanel.new(
        'Node $node - Local Processes',//title
        description='Memory allocated on this node while a process was running on it.',
        fill=2,
        linewidth=2,
        decimals=2,
        datasource='Prometheus',
        pointradius=5,
        paceLength=10,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sortDesc=true,
        legend_sort='avg',
        editable=true,
        formatY1='ops',
        formatY2='short',
       )
      .addTarget(
          prometheus.target(
            'rate(node_memory_numa_local_node_total{node_name=~"$host",node="$node"}[$interval]) or
            irate(node_memory_numa_local_node_total{node_name=~"$host",node="$node"}[$interval])',
            refId='A',
            interval='$interval',
            legendFormat='Node $node',
            intervalFactor=1,
           )
            ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 0,
        "y": 37,
       }
    )//31 graph
    .addPanel(
      graphPanel.new(
        'Node $node - Remote Processes',//title
        description='Memory allocated on this node while a process was running on some other node.',
        fill=2,
        linewidth=2,
        decimals=2,
        datasource='Prometheus',
        pointradius=5,
        paceLength=10,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sortDesc=true,
        legend_sort='avg',
        editable=true,
        formatY1='ops',
        formatY2='short',
       )
      .addTarget(
          prometheus.target(
            'rate(node_memory_numa_other_node_total{node_name=~"$host", node="$node"}[$interval]) or
            irate(node_memory_numa_other_node_total{node_name=~"$host", node="$node"}[5m])',
            refId='A',
            interval='$interval',
            legendFormat='Node $node',
            intervalFactor=1,
           )
        ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 12,
        "y": 37,
       }
    )//33 graph
    .addPanel(
      graphPanel.new(
        'Node $node - Slab Memory',//title
        description="**Slab** allocation is a memory management mechanism intended for the efficient memory allocation of kernel objects.\n\n**SReclaimable** The part of the Slab that might be reclaimed (such as caches).\n\n**SUnreclaim** The part of the Slab that can't be reclaimed under memory pressure",
        fill=2,
        linewidth=2,
        decimals=2,
        datasource='Prometheus',
        pointradius=5,
        paceLength=10,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sortDesc=true,
        legend_sort='avg',
        editable=true,
        formatY1='bytes',
        formatY2='short',
        stack=true,
        aliasColors={
            "Total": "#bf1b00"
          },
       )
      .addSeriesOverride(
        {
           "alias": "Total",
           "color": "#bf1b00",
           "points": true,
           "stack": false,
         }
       )
      .addTarget(
          prometheus.target(
            'avg_over_time(node_memory_numa_Slab{node_name=~"$host", node="$node"}[$interval])',
            refId='A',
            interval='$interval',
            legendFormat='Total',
            intervalFactor=1,
           )
        )
      .addTarget(
              prometheus.target(
                'avg_over_time(node_memory_numa_SReclaimable{node_name=~"$host", node="$node"}[$interval])',
                refId='B',
                interval='$interval',
                legendFormat='Reclaimable',
                intervalFactor=1,
              )
            )
      .addTarget(
                prometheus.target(
                  'avg_over_time(node_memory_numa_SUnreclaim{node_name=~"$host", node="$node"}[$interval])',
                  refId='C',
                  interval='$interval',
                  legendFormat='Unreclaim',
                  intervalFactor=1,
                 )
              ),
      gridPos={
           "h": 7,
           "w": 12,
           "x": 0,
           "y": 44,
       }
    )//45 graph
    ,gridPos={
     "h": 1,
     "w": 24,
     "x": 0,
     "y": 50,
     },
     style=null,
)//13 row
.addPanel(
  text.new(
    content='<h1><i><font color=#5991A7><b><center>Free Memory Pages</center></b></font></i></h1>\n\n\n',
    description="/proc/buddyinfo gives you an idea about the free memory fragments on your Linux box. You get to view the free fragments for each available order, for different zones of each numa node.\n\nNote: Non-Uniform Memory Access (NUMA) refers to multiprocessor systems whose memory is divided into multiple memory nodes.\n\nEach NUMA node is an entry in the kernel linked list pgdat_list. Each node is further divided into zones. Here are some example zone types:\n\nDMA Zone: Lower 16 MiB of RAM used by legacy devices that cannot address anything beyond the first 16MiB of RAM.\n\nDMA32 Zone (only on x86_64): Some devices can't address beyond the first 4GiB of RAM. On x86, this zone would probably be covered by Normal zone\n\nNormal Zone: Anything above zone DMA and doesn't require kernel tricks to be addressable. Typically on x86, this is 16MiB to 896MiB. Many kernel operations require that the memory being used be from this zone\n\nHighmem Zone (x86 only): Anything above 896MiB.",
    mode='html',
  ),
  gridPos={
    "h": 2,
    "w": 24,
    "x": 0,
    "y": 51,
  },
  style=null,
)//66 text
.addPanel(
    row.new(
      title='Total',
      collapse=true,
    )
    .addPanel(
      graphPanel.new(
        'Zone $zone',//title
        description='Formula for chunks of memory 2^(Size * PAGE_SIZE) ',
        fill=1,
        linewidth=1,
        decimals=0,
        datasource='Prometheus',
        pointradius=2,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_rightSide=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sortDesc=true,
        legend_sort='avg',
        decimalsY1=0,
        repeat='zone',
        repeatDirection='v',
       )
      .addTarget(
          prometheus.target(
            'sum by (node,zone,size) (node_buddyinfo_blocks{node_name=~"$host", zone=~"$zone"})',
            refId='A',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Size {{size}}'
          )
        ),
      gridPos={
           "h": 8,
           "w": 24,
           "x": 0,
           "y": 54,
       }
    )//51 graph
    ,gridPos={
                "h": 1,
                "w": 24,
                "x": 0,
                "y": 53
            },
    style=null,
)//58 row
.addPanel(
    row.new(
      title='Node $node',
      collapse=true,
      repeat='node',
    )
    .addPanel(
      graphPanel.new(
        'Node $node - Zone $zone',//title
        description='Formula for chunks of memory 2^(Size * PAGE_SIZE) ',
        fill=1,
        linewidth=1,
        decimals=0,
        pointradius=2,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_rightSide=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sortDesc=true,
        legend_sort='avg',
        decimalsY1=0,
        repeat='zone',
        repeatDirection='v',
       )
      .addTarget(
          prometheus.target(
            'sum by (node,zone,size) (node_buddyinfo_blocks{node_name=~"$host", node="$node", zone=~"$zone"})',
            refId='A',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Size {{size}}'
          )
        ),
      gridPos={
            "h": 8,
            "w": 24,
            "x": 0,
            "y": 55
       }
    )//52 graph
    ,gridPos={
           "h": 1,
           "w": 24,
           "x": 0,
           "y": 54
     },
     style=null,
)//70 row
