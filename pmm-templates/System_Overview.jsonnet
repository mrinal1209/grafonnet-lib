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
local pmmSinglestat = grafana.pmmSinglestat;


dashboard.new(
  'System Overview',
  time_from='now-12h',
  editable=false,
  refresh= "1m",
  graphTooltip='shared_crosshair',
  schemaVersion=18,
  version=4,
  tags=['OS','Percona'],
  iteration=1563457631837,
  uid="qyzrQGHmk",
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
  'label_values(node_load1, node_name)',
  label='Host',
  refresh='load',
  sort=1,
  tagsQuery='up',
  tagValuesQuery='instance',
  allFormat='glob',
  multiFormat='regex values',
  multi=false,
  skipUrlSync=false,
  definition='label_values(node_load1, node_name)',
  includeAll=false,
  )
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
)//36 text
.addPanel(
  singlestat.new(
    'System Uptime',//title
    format='s',
    datasource='Prometheus',
    valueName='current',
    decimals=1,
    colorValue=true,
    thresholds='300,3600',
    colors=[
      "rgba(245, 54, 54, 0.9)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(50, 172, 45, 0.97)",
    ],
    height='125px',
    valueMaps=[],
    postfix='s',
    prefixFontSize='70%',
    valueFontSize='50%',
    interval='$interval',
    editable=true,
  )
  .addTarget(
    prometheus.target(
      '(node_time_seconds{node_name=~"$host"} - node_boot_time_seconds{node_name=~"$host"}) or (time() - node_boot_time_seconds{node_name=~"$host"})',
      intervalFactor = 1,
      refId='A',
      interval='5m',
      calculatedInterval='10m',
      step=300,
    )
  ),
  gridPos = {
    "h": 2,
    "w": 3,
    "x": 0,
    "y": 2,
    },
  style=null,
)//19 singlestat
.addPanel(
  singlestat.new(
    'Virtual CPUs',//title
    colorValue=false,
    format='none',
    datasource='Prometheus',
    valueName='current',
    thresholds='',
    colors=[
      "rgba(245, 54, 54, 0.9)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(50, 172, 45, 0.97)",
    ],
    height='125px',
    prefixFontSize='80%',
    interval='$interval',
    editable=true,
  )
  .addTarget(
    prometheus.target(
      '(count(node_cpu_seconds_total{node_name=~"$host",mode=~"user"}) or (1-absent(node_cpu_seconds_total{node_name=~"$host",mode=~"user"}))) + sum(rdsosmetrics_General_numVCPUs{node_name=~"$host"} or up * 0)',
      intervalFactor = 1,
      refId='A',
      interval='5m',
      step=300,
    )
  ),
  gridPos = {
    "h": 2,
    "w": 3,
    "x": 3,
    "y": 2,
    },
  style=null,
)//25 singlestat
.addPanel(
  pmmSinglestat.new(
    'Load Average',//title
    colorValue=true,
    format='none',
    datasource='Prometheus',
    valueName='current',
    decimals=2,
    thresholds='10,20',
    sparklineShow=true,
    colors=[
        "#299c46",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
  )
  .addTarget(
    prometheus.target(
      'avg_over_time(node_load1{node_name=~"$host"}[$interval]) or avg_over_time(node_load1{node_name=~"$host"}[5m])',
      intervalFactor = 1,
      interval='$interval',
    )
  ),
  gridPos = {
    "h": 2,
    "w": 3,
    "x": 6,
    "y": 2,
    },
  style=null,
)//57 pmm-singlestat
.addPanel(
  singlestat.new(
    'RAM',//title
    colorValue=false,
    format='bytes',
    datasource='Prometheus',
    valueName='current',
    decimals=2,
    thresholds='',
    colors=[
      "rgba(245, 54, 54, 0.9)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(50, 172, 45, 0.97)",
    ],
    height='125px',
    prefixFontSize='80%',
    valueFontSize='50%',
    interval='$interval',
    editable=true,
  )
  .addTarget(
    prometheus.target(
      'node_memory_MemTotal_bytes{node_name=~"$host"}',
      intervalFactor = 1,
      refId='A',
      interval='5m',
      step=300,
    )
  ),
  gridPos = {
    "h": 2,
    "w": 3,
    "x": 9,
    "y": 2,
    },
  style=null,
)//26 singlestat
.addPanel(
  pmmSinglestat.new(
    'Memory Available',//title
    description='Percent of Memory Available\nNote: on Modern Linux Kernels amount of Memory Available for application is not the same as Free+Cached+Buffers',
    colorValue=true,
    format='percent',
    datasource='Prometheus',
    valueName='current',
    thresholds='5,10',
    sparklineShow=true,
    colors=[
      "#d44a3a",
      "rgba(237, 129, 40, 0.89)",
      "#299c46",
    ],
  )
  .addTarget(
    prometheus.target(
      '(node_memory_MemAvailable_bytes{node_name=~"$host"} or (node_memory_MemFree_bytes{node_name=~"$host"} + node_memory_Buffers_bytes{node_name=~"$host"} + node_memory_Cached_bytes{node_name=~"$host"})) / node_memory_MemTotal_bytes{node_name=~"$host"} * 100',
      intervalFactor = 1,
      interval='$interval',
    )
  ),
  gridPos = {
    "h": 2,
    "w": 3,
    "x": 12,
    "y": 2,
    },
  style=null,
)//55 pmm-singlestat
.addPanel(
  singlestat.new(
    'Virtual Memory',//title
    description='RAM + SWAP',
    colorValue=false,
    format='bytes',
    datasource='Prometheus',
    valueName='current',
    decimals=2,
    thresholds='',
    colors=[
      "rgba(245, 54, 54, 0.9)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(50, 172, 45, 0.97)",
    ],
    height='125px',
    prefixFontSize='80%',
    valueFontSize='50%',
    interval='$interval',
    editable=true,
  )
  .addTarget(
    prometheus.target(
      'node_memory_MemTotal_bytes{node_name=~"$host"}+node_memory_SwapTotal_bytes{node_name=~"$host"}',
      intervalFactor = 1,
      refId='A',
      interval='5m',
      step=300,
    )
  ),
  gridPos = {
    "h": 2,
    "w": 3,
    "x": 15,
    "y": 2,
    },
  style=null,
)//37 singlestat
.addPanel(
  singlestat.new(
    'Disk Space',//title
    description='Sum of disk space on all partitions. Note  it can be significantly over-reported in some installations',
    colorValue=false,
    format='bytes',
    datasource='Prometheus',
    valueName='current',
    decimals=2,
    thresholds='',
    colors=[
      "rgba(245, 54, 54, 0.9)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(50, 172, 45, 0.97)",
    ],
    height='125px',
    prefixFontSize='80%',
    valueFontSize='50%',
    interval='$interval',
    editable=true,
    links=[
                {
                    "dashboard": "Disk Space",
                    "dashUri": "db/disk-space",
                    "includeVars": true,
                    "keepTime": true,
                    "targetBlank": true,
                    "title": "Disk Space",
                    "type": "dashboard"
                }
            ],
  )
  .addTarget(
    prometheus.target(
      'sum(avg(node_filesystem_size_bytes{node_name=~"$host",fstype=~"(ext.|xfs|vfat)"}) without (mountpoint)) without (device,fstype)',
      intervalFactor = 1,
      refId='A',
      interval='5m',
      step=300,
    )
  ),
  gridPos = {
    "h": 2,
    "w": 3,
    "x": 18,
    "y": 2,
    },
  style=null,
)//38 singlestat
.addPanel(
  pmmSinglestat.new(
    'Min Space Available',//title
    description='Lowest percent of the disk space available',
    colorValue=true,
    format='percent',
    datasource='Prometheus',
    valueName='current',
    thresholds='5,20',
    sparklineShow=true,
    colors=[
      "#d44a3a",
      "rgba(237, 129, 40, 0.89)",
      "#299c46",
    ],
  )
  .addTarget(
    prometheus.target(
      'min(node_filesystem_free_bytes{node_name=~"$host", fstype!~"rootfs|selinuxfs|autofs|rpc_pipefs|tmpfs|shm|overlay|squashfs"}/node_filesystem_size_bytes{node_name=~"$host", fstype!~"rootfs|selinuxfs|autofs|rpc_pipefs|tmpfs|shm|overlay|squashfs"})*100',
      intervalFactor = 1,
      interval='$interval',
    )
  ),
  gridPos = {
    "h": 2,
    "w": 3,
    "x": 21,
    "y": 2,
    },
  style=null,
)//59 pmm-singlestat
.addPanel(
    row.new(
      title='CPU',
    ),
    gridPos={
    "h": 1,
    "w": 24,
    "x": 0,
    "y": 4,
    },
    style=null,
)//49 row
.addPanel(
  graphPanel.new(
    'CPU Usage',//title
    fill=5,
    linewidth=1,
    decimals=2,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_rightSide=false,
    legend_hideEmpty=true,
    legend_hideZero=true,
    legend_show=true,
    legend_sort='avg',
    legend_sortDesc=true,
    editable=true,
    stack=true,
    aliasColors={
      "Max Core Utilization": "#bf1b00",
      "idle": "#806EB7",
      "iowait": "#E24D42",
      "nice": "#1F78C1",
      "softirq": "#806EB7",
      "system": "#EAB839",
      "user": "#508642",
    },
    formatY1='percent',
    maxY1='100',
    min=0,
  )
  .addSeriesOverride(
       {
          "alias": "Max Core Utilization",
          "lines": false,
          "pointradius": 1,
          "points": true,
          "stack": false,
        },
  )
  .addTarget(
      prometheus.target(
        'clamp_max(((avg by (mode) ( (clamp_max(rate(node_cpu_seconds_total{node_name=~"$host",mode!="idle"}[$interval]),1)) or (clamp_max(irate(node_cpu_seconds_total{node_name=~"$host",mode!="idle"}[5m]),1)) ))*100 or (avg_over_time(node_cpu_average{node_name=~"$host", mode!="total", mode!="idle"}[$interval]) or avg_over_time(node_cpu_average{node_name=~"$host", mode!="total", mode!="idle"}[5m]))),100)',
        interval='$interval',
        intervalFactor=1,
        legendFormat='{{ mode }}'
      )
  )
  .addTarget(
      prometheus.target(
        'clamp_max(max by () (sum  by (cpu) ( (clamp_max(rate(node_cpu_seconds_total{node_name=~"$host",mode!="idle",mode!="iowait"}[$interval]),1)) or (clamp_max(irate(node_cpu_seconds_total{node_name=~"$host",mode!="idle",mode!="iowait"}[5m]),1)) )),1)',
        interval='$interval',
        legendFormat='Max Core Utilization',
        intervalFactor=1,
        hide=true,
      )
  ),
  gridPos={
    "h": 8,
     "w": 12,
     "x": 0,
     "y": 5,
  },
  style=null,
)//2 graph
.addPanel(
  graphPanel.new(
    'CPU Saturation and Max Core Usage',//title
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
    legend_sort='avg',
    legend_sortDesc=true,
    editable=true,
    aliasColors={
        "Allocated": "#E0752D",
        "CPU Load": "#64B0C8",
        "IO Load ": "#EA6460",
        "Limit": "#1F78C1",
        "Max CPU Core Utilization": "#bf1b00",
        "Max Core Usage": "#bf1b00",
        "Normalized CPU Load": "#6ED0E0"
      },
    formatY2='percentunit',
    maxY2='1',
    min=0,
  )
  .addSeriesOverride(
       {
          "alias": "Max CPU Core Utilization",
          "lines": false,
          "pointradius": 1,
          "points": true,
          "yaxis": 2,
        },
  )
  .addTarget(
      prometheus.target(
        '(avg_over_time(node_procs_running{node_name=~"$host"}[$interval])-1) / scalar(count(node_cpu_seconds_total{mode="user", node_name=~"$host"})) or (avg_over_time(node_procs_running{node_name=~"$host"}[5m])-1) / scalar(count(node_cpu_seconds_total{mode="user", node_name=~"$host"}))',
        calculatedInterval='2s',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Normalized CPU Load',
        step=300,
      )
  )
  .addTarget(
      prometheus.target(
        'clamp_max(max by () (sum  by (cpu) ( (clamp_max(rate(node_cpu_seconds_total{node_name=~"$host",mode!="idle",mode!="iowait"}[$interval]),1)) or (clamp_max(irate(node_cpu_seconds_total{node_name=~"$host",mode!="idle",mode!="iowait"}[5m]),1)) )),1)',
        calculatedInterval='2s',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Max CPU Core Utilization',
        step=300,
      )
  ),
  gridPos={
    "h": 8,
     "w": 12,
     "x": 12,
     "y": 5,
  },
  style=null,
)//33 graph
.addPanel(
  graphPanel.new(
    'Interrupts and Context Switches',//title
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
    legend_sort='avg',
    legend_sortDesc=true,
    editable=true,
    min=0,
  )
  .addSeriesOverride(
    {
        "alias": "Context Switches per Virtual CPU",
        "lines": false
      }
  )
  .addTarget(
      prometheus.target(
        'rate(node_context_switches_total{node_name=~"$host"}[$interval]) or irate(node_context_switches_total{node_name=~"$host"}[5m])',
        calculatedInterval='2m',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Context Switches',
        step=300,
      )
  )
  .addTarget(
      prometheus.target(
        '(rate(node_context_switches_total{node_name=~"$host"}[$interval]) or irate(node_context_switches_total{node_name=~"$host"}[5m])) / scalar(count(node_cpu_seconds_total{mode="user", node_name=~"$host"}))',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Context Switches per Virtual CPU',
        step=60,
      )
  )
  .addTarget(
      prometheus.target(
        'rate(node_intr_total{node_name=~"$host"}[$interval]) or irate(node_intr_total{node_name=~"$host"}[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Interrupts',
        step=60,
      )
  ),
  gridPos={
      "h": 7,
      "w": 12,
      "x": 0,
      "y": 13,
  },
  style=null,
)//27 graph
.addPanel(
  graphPanel.new(
    'Processes',//title
    fill=2,
    linewidth=2,
    decimals=2,
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
    editable=true,
    stack=true,
    min=0,
    formatY2='ops',
    aliasColors={
        "Blocked Processes": "#e24d42",
        "Created Processes (Forks)": "#e0752d",
        "Forks": "#f9934e",
        "Interrupts": "#1f78c1",
        "Runnable Processes": "#6ed0e0"
      }
  )
  .addSeriesOverride(
      {
         "alias": "Created Processes (Forks)",
         "bars": false,
         "pointradius": 1,
         "points": true,
         "stack": false,
         "yaxis": 2
       }
  )
  .addTarget(
      prometheus.target(
        '(avg_over_time(node_procs_running{node_name=~"$host"}[$interval]) - 1) or (avg_over_time(node_procs_running{node_name=~"$host"}[5m]) -1)',
        calculatedInterval='2m',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Runnable Processes',
        step=300,
      )
  )
  .addTarget(
      prometheus.target(
        'avg_over_time(node_procs_blocked{node_name=~"$host"}[$interval]) or avg_over_time(node_procs_blocked{node_name=~"$host"}[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Blocked Processes',
      )
  )
  .addTarget(
      prometheus.target(
        'rate(node_forks_total{node_name=~"$host"}[$interval]) or irate(node_forks_total{node_name=~"$host"}[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Created Processes (Forks)',
      )
  ),
  gridPos={
      "h": 7,
      "w": 12,
      "x": 12,
      "y": 13,
  },
  style=null,
)//43 graph
.addPanel(
    row.new(
      title='Memory',
    ),
    gridPos={
      "h": 1,
         "w": 24,
         "x": 0,
         "y": 20,
    },
    style=null,
)//47 row
.addPanel(
  graphPanel.new(
    'Memory Utilization',//title
    fill=10,
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
    legend_sort='avg',
    legend_sortDesc=true,
    editable=true,
    stack=true,
    min=0,
    format='bytes',
    aliasColors={
        "Cached": "#1f78c1",
        "Free": "#508642",
        "Total": "#bf1b00",
        "Used": "#eab839"
      },
  )
  .addSeriesOverride(
    {
       "alias": "Total",
       "fill": 0,
       "stack": false
     }
  )
  .addTarget(
      prometheus.target(
        'node_memory_MemTotal_bytes{node_name=~"$host"}',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Total',
      )
  )
  .addTarget(
      prometheus.target(
        'node_memory_MemFree_bytes{node_name=~"$host"}',
        calculatedInterval='2s',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Free',
        step=300,
      )
  )
  .addTarget(
      prometheus.target(
        'node_memory_Buffers_bytes{node_name=~"$host"}',
        calculatedInterval='2s',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Buffers',
        step=300,
      )
  )
  .addTarget(
      prometheus.target(
        'max(node_memory_Cached_bytes{node_name=~"$host",job=~"rds-enhanced|linux"}) without (job) or
        max(node_memory_Cached_bytes{node_name=~"$host",job=~"rds-basic"}) without (job)',
        calculatedInterval='2s',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Cached',
        step=300,
      )
  )
  .addTarget(
      prometheus.target(
        'node_memory_MemTotal_bytes{node_name=~"$host"} - (node_memory_MemFree_bytes{node_name=~"$host"} + node_memory_Buffers_bytes{node_name=~"$host"} + node_memory_Cached_bytes{node_name=~"$host"})',
        calculatedInterval='2s',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Used',
        step=300,
      )
  ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 21,
  },
  style=null,
)//29 graph
.addPanel(
  graphPanel.new(
    'Virtual Memory Utilization',//title
    fill=6,
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
    legend_sort='avg',
    legend_sortDesc=true,
    editable=true,
    stack=true,
    min=0,
    format='bytes',
    aliasColors={
        "Available": "#629e51",
        "Total": "#bf1b00",
        "Used": "#eab839"
      },
  )
  .addSeriesOverride(
    {
       "alias": "Total",
       "fill": 0,
       "stack": false
     }
  )
  .addTarget(
      prometheus.target(
        'node_memory_MemTotal_bytes{node_name=~"$host"} + node_memory_SwapTotal_bytes{node_name=~"$host"}',
        calculatedInterval='2s',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Total',
        step=300,
      )
  )
  .addTarget(
      prometheus.target(
        '(node_memory_MemAvailable_bytes{node_name=~"$host"} or
        (node_memory_MemFree_bytes{node_name=~"$host"} + node_memory_Buffers_bytes{node_name=~"$host"} + node_memory_Cached_bytes{node_name=~"$host"})) +
        node_memory_SwapFree_bytes{node_name=~"$host"}',
        calculatedInterval='2s',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Available',
        step=300,
      )
  )
  .addTarget(
      prometheus.target(
        'node_memory_MemTotal_bytes{node_name=~"$host"} + node_memory_SwapTotal_bytes{node_name=~"$host"} -
        ((node_memory_MemAvailable_bytes{node_name=~"$host"} or
        (node_memory_MemFree_bytes{node_name=~"$host"} + node_memory_Buffers_bytes{node_name=~"$host"} + node_memory_Cached_bytes{node_name=~"$host"})) +
        node_memory_SwapFree_bytes{node_name=~"$host"})',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Used',
      )
  ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 12,
    "y": 21,
  },
  style=null,
)//6 graph
.addPanel(
  graphPanel.new(
    'Swap Space',//title
    fill=10,
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
    legend_sort='avg',
    legend_sortDesc=true,
    editable=true,
    stack=true,
    min=0,
    format='bytes',
    aliasColors={
        "Free": "#7eb26d",
        "Total": "#bf1b00",
        "Used": "#f2c96d"
      },
  )
  .addSeriesOverride(
    {
       "alias": "Total",
       "fill": 0,
       "stack": false
     }
  )
  .addTarget(
      prometheus.target(
        'node_memory_SwapTotal_bytes{node_name=~"$host"} - node_memory_SwapFree_bytes{node_name=~"$host"}',
        calculatedInterval='2s',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Used',
        step=300,
      )
  )
  .addTarget(
      prometheus.target(
        'node_memory_SwapFree_bytes{node_name=~"$host"}',
        calculatedInterval='2s',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Free',
        step=300,
      )
  )
  .addTarget(
      prometheus.target(
        'node_memory_SwapTotal_bytes{node_name=~"$host"}',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Total',
      )
  ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 28,
  },
  style=null,
)//23 graph
.addPanel(
  graphPanel.new(
    'Swap Activity',//title
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
    legend_sort='avg',
    legend_sortDesc=true,
    editable=true,
    minY2=0,
    formatY1='Bps',
    formatY2='bytes',
    labelY1='Swap out (-) / Swap in (+)',
    aliasColors={
        "Total": "#bf1b00",
        "Total ": "#bf1b00"
      },
  )
  .addSeriesOverride(
    {
          "alias": "Swap Out (Writes)",
          "transform": "negative-Y"
        }
  )
  .addSeriesOverride(
    {
       "alias": "Total",
       "legend": false,
        "lines": false
     }
  )
  .addTarget(
      prometheus.target(
        'rate(node_vmstat_pswpin{node_name=~"$host"}[$interval]) * 4096 or irate(node_vmstat_pswpin{node_name=~"$host"}[5m]) * 4096',
        calculatedInterval='2s',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Swap In (Reads)',
        step=300,
      )
  )
  .addTarget(
      prometheus.target(
        'rate(node_vmstat_pswpout{node_name=~"$host"}[$interval]) * 4096 or irate(node_vmstat_pswpout{node_name=~"$host"}[5m]) * 4096',
        calculatedInterval='2s',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Swap Out (Writes)',
        step=300,
      )
  )
  .addTarget(
      prometheus.target(
        '(rate(node_vmstat_pswpin{node_name=~"$host"}[$interval]) * 4096 or irate(node_vmstat_pswpin{node_name=~"$host"}[5m]) * 4096) + (rate(node_vmstat_pswpout{node_name=~"$host"}[$interval]) * 4096 or irate(node_vmstat_pswpout{node_name=~"$host"}[5m]) * 4096)',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Total',
      )
  ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 12,
    "y": 28,
  },
  style=null,
)//30 graph
.addPanel(
    row.new(
      title='Disk',
    ),
    gridPos={
        "h": 1,
         "w": 24,
         "x": 0,
         "y": 35,
    },
    style=null,
)//45 row
.addPanel(
  graphPanel.new(
    'I/O Activity',//title
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
    legend_sort='avg',
    legend_sortDesc=true,
    editable=true,
    minY2=0,
    formatY1='Bps',
    formatY2='bytes',
    labelY1='Page Out (-) / Page In (+)',
    links=[
        {
          "dashUri": "db/disk-performance",
          "dashboard": "Disk Performance",
          "includeVars": true,
          "keepTime": true,
          "targetBlank": true,
          "title": "Disk Performance",
          "type": "dashboard"
        }
      ],
    aliasColors={
        "Total": "#bf1b00",
      },
  )
  .addSeriesOverride(
    {
        "alias": "Disk Writes (Page Out)",
        "transform": "negative-Y"
      }
  )
  .addSeriesOverride(
    {
       "alias": "Total",
       "legend": false,
        "lines": false
     }
  )
  .addTarget(
      prometheus.target(
        'rate(node_vmstat_pgpgin{node_name=~"$host"}[$interval]) * 1024 or irate(node_vmstat_pgpgin{node_name=~"$host"}[5m]) * 1024',
        calculatedInterval='2s',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Disk Reads (Page In)',
        step=300,
      )
  )
  .addTarget(
      prometheus.target(
        '(rate(node_vmstat_pgpgout{node_name=~"$host"}[$interval]) * 1024 or irate(node_vmstat_pgpgout{node_name=~"$host"}[5m]) * 1024)',
        calculatedInterval='2s',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Disk Writes (Page Out)',
        step=300,
      )
  )
  .addTarget(
      prometheus.target(
        '(rate(node_vmstat_pgpgin{node_name=~"$host"}[$interval]) * 1024 or irate(node_vmstat_pgpgin{node_name=~"$host"}[5m]) * 1024 ) + (rate(node_vmstat_pgpgout{node_name=~"$host"}[$interval]) * 1024 or irate(node_vmstat_pgpgout{node_name=~"$host"}[5m]) * 1024)',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Total',
      )
  ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 36,
  },
  style=null,
)//31 graph
.addPanel(
  graphPanel.new(
    'Global File Descriptors Usage',//title
    fill=2,
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
    editable=true,
    min=0,
    aliasColors={
        "Allocated": "#E0752D",
        "Limit": "#bf1b00"
      },
  )
  .addSeriesOverride(
      {
        "alias": "Limit",
        "fill": 0
      }
  )
  .addTarget(
      prometheus.target(
        'node_filefd_maximum{node_name=~"$host"}',
        calculatedInterval='2s',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Limit',
        step=300,
      )
  )
  .addTarget(
      prometheus.target(
        'node_filefd_allocated{node_name=~"$host"}',
        calculatedInterval='2s',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Allocated',
        step=300,
      )
  ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 12,
    "y": 36,
  },
  style=null,
)//32 graph
.addPanel(
  graphPanel.new(
    'Disk IO Latency',//title
    description='Shows average latency for Reads and Writes IO Devices.  Higher than typical latency for highly loaded storage indicates saturation (overload) and is frequent cause of performance problems.  Higher than normal latency also can indicate internal storage problems.',
    decimals=2,
    fill=2,
    linewidth=2,
    datasource='Prometheus',
    lines=false,
    points=true,
    pointradius=1,
    paceLength=10,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    legend_sort='avg',
    legend_sortDesc=true,
    legend_hideEmpty=true,
    legend_hideZero=true,
    editable=true,
    decimalsY1=2,
    formatY1='s',
    logBase1Y=2,
    aliasColors={
        "Read Latency": "#1f78c1",
        "Write Latency": "#e24d42"
      },
  )
  .addSeriesOverride(
    {
        "alias": "Avg Read Latency (1h)",
        "fill": 0,
        "lines": true,
        "linewidth": 1,
        "points": false
      }
  )
  .addSeriesOverride(
    {
        "alias": "Avg Write Latency (1h)",
        "fill": 0,
        "lines": true,
        "linewidth": 1,
        "points": false
      }
  )
  .addTarget(
      prometheus.target(
        '(sum(rate(node_disk_read_time_seconds_total{node_name=~"$host"}[$interval])) / sum(rate(node_disk_reads_completed_total{node_name=~"$host"}[$interval]))) or (sum(irate(node_disk_read_time_seconds_total{node_name=~"$host"}[5m])) / sum(irate(node_disk_reads_completed_total{node_name=~"$host"}[5m])))
        or avg_over_time(aws_rds_read_latency_average{node_name=~"$host"}[$interval])/1000 or avg_over_time(aws_rds_read_latency_average{node_name=~"$host"}[5m])/1000',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Read Latency',
      )
  )
  .addTarget(
      prometheus.target(
        '(sum(rate(node_disk_write_time_seconds_total{node_name=~"$host"}[$interval])) / sum(rate(node_disk_writes_completed_total{node_name=~"$host"}[$interval]))) or (sum(irate(node_disk_write_time_seconds_total{node_name=~"$host"}[5m])) / sum(irate(node_disk_writes_completed_total{node_name=~"$host"}[5m])))
        or (avg_over_time(aws_rds_write_latency_average{node_name=~"$host"}[$interval])/1000 or avg_over_time(aws_rds_write_latency_average{node_name=~"$host"}[5m])/1000)',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Write Latency',
      )
  )
  .addTarget(
      prometheus.target(
        '(sum(rate(node_disk_read_time_seconds_total{node_name=~"$host"}[1h])) / sum(rate(node_disk_reads_completed_total{node_name=~"$host"}[1h])))
        or avg_over_time(aws_rds_read_latency_average{node_name=~"$host"}[1h])/1000 or avg_over_time(aws_rds_read_latency_average{node_name=~"$host"}[1h])/1000',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Avg Read Latency (1h)',
      )
  )
  .addTarget(
      prometheus.target(
        '(sum(rate(node_disk_write_time_seconds_total{node_name=~"$host"}[1h])) / sum(rate(node_disk_writes_completed_total{node_name=~"$host"}[1h])))
        or (avg_over_time(aws_rds_write_latency_average{node_name=~"$host"}[$interval])/1000 or avg_over_time(aws_rds_write_latency_average{node_name=~"$host"}[1h])/1000)',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Avg Write Latency (1h)',
      )
  ),
  gridPos={
    "h": 7,
     "w": 12,
     "x": 0,
     "y": 43,
  },
  style=null,
)//61 graph
.addPanel(
  graphPanel.new(
    'Disk IO Load',//title
    description='Shows how much disk was loaded for reads or writes as average number of outstanding requests at different period of time.  High disk load is a good measure of actual storage utilization. Different storage types handle load differently - some will show latency increases on low loads others can handle higher load with no problems.',
    decimals=2,
    fill=2,
    linewidth=2,
    datasource='Prometheus',
    pointradius=1,
    paceLength=10,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    legend_sort='avg',
    legend_sortDesc=true,
    legend_hideEmpty=true,
    legend_hideZero=true,
    editable=true,
    labelY1='Write Load (-) / Read Load (+)',
    minY2=0,
    formatY2='s',
    links=[
        {
          "dashUri": "db/disk-performance",
          "dashboard": "Disk Performance",
          "includeVars": true,
          "keepTime": true,
          "targetBlank": true,
          "title": "Disk Performance",
          "type": "dashboard"
        }
      ],
    aliasColors={
        "Total": "#bf1b00"
      },
  )
  .addSeriesOverride(
      {
          "alias": "Write Load",
          "transform": "negative-Y"
        }
  )
  .addSeriesOverride(
      {
            "alias": "Total",
            "legend": false,
            "lines": false
          }
  )
  .addTarget(
      prometheus.target(
        'sum(rate(node_disk_read_time_seconds_total{node_name=~"$host"}[$interval])) or sum(irate(node_disk_read_time_seconds_total{node_name=~"$host"}[5m]))',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Read Load',
        calculatedInterval='2m',
        step=300,
      )
  )
  .addTarget(
      prometheus.target(
        'sum(rate(node_disk_write_time_seconds_total{node_name=~"$host"}[$interval])) or sum(irate(node_disk_write_time_seconds_total{node_name=~"$host"}[5m]))',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Write Load',
        calculatedInterval='2m',
        step=300,
      )
  )
  .addTarget(
      prometheus.target(
        '(sum(rate(node_disk_read_time_seconds_total{node_name=~"$host"}[$interval])) or sum(irate(node_disk_read_time_seconds_total{node_name=~"$host"}[5m]))) + (sum(rate(node_disk_write_time_seconds_total{node_name=~"$host"}[$interval])) or sum(irate(node_disk_write_time_seconds_total{node_name=~"$host"}[5m])))',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Total',
      )
  ),
  gridPos={
    "h": 7,
     "w": 12,
     "x": 12,
     "y": 43,
  },
  style=null,
)//51 graph
.addPanel(
    row.new(
      title='Network',
    ),
    gridPos={
        "h": 1,
         "w": 24,
         "x": 0,
         "y": 50,
    },
    style=null,
)//42 row
.addPanel(
  graphPanel.new(
    'Network Traffic',//title
    decimals=2,
    fill=2,
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
    editable=true,
    formatY1='Bps',
    labelY1='Outbound (-) / Inbound (+)',
    minY2=0,
    formatY2='bytes',
  )
  .addSeriesOverride(
      {
        "alias": "Outbound",
        "transform": "negative-Y"
      }
  )
  .addTarget(
      prometheus.target(
        'sum(rate(node_network_receive_bytes_total{node_name=~"$host", device!="lo"}[$interval])) or sum(irate(node_network_receive_bytes_total{node_name=~"$host", device!="lo"}[5m])) or sum(max_over_time(rdsosmetrics_network_rx{node_name=~"$host"}[$interval])) or sum(max_over_time(rdsosmetrics_network_rx{node_name=~"$host"}[5m])) ',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Inbound',
        calculatedInterval='2s',
        step=300,
      )
  )
  .addTarget(
      prometheus.target(
        'sum(rate(node_network_transmit_bytes_total{node_name=~"$host", device!="lo"}[$interval])) or sum(irate(node_network_transmit_bytes_total{node_name=~"$host", device!="lo"}[5m])) or
        sum(max_over_time(rdsosmetrics_network_tx{node_name=~"$host"}[$interval])) or sum(max_over_time(rdsosmetrics_network_tx{node_name=~"$host"}[5m]))',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Outbound',
        calculatedInterval='2s',
        step=300,
      )
  ),
  gridPos={
    "h": 7,
     "w": 12,
     "x": 0,
     "y": 51,
  },
  style=null,
)//21 graph
.addPanel(
  graphPanel.new(
    'Network Utilization Hourly',//title
    decimals=2,
    fill=6,
    linewidth=2,
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
    editable=true,
    stack=true,
    min=0,
    format='bytes',
    timeFrom='24h',
    aliasColors={
        "Total": "#bf1b00"
      },
  )
  .addSeriesOverride(
    {
       "alias": "Total",
       "bars": false,
       "stack": false
     }
    )
  .addTarget(
      prometheus.target(
        'sum(increase(node_network_receive_bytes_total{node_name=~"$host", device!="lo"}[1h])) or sum(increase(rdsosmetrics_network_rx{node_name=~"$host", device!="lo"}[1h]))',
        interval='1h',
        intervalFactor=1,
        legendFormat='Received',
        calculatedInterval='2s',
        step=3600,
      )
  )
  .addTarget(
      prometheus.target(
        'sum(increase(node_network_transmit_bytes_total{node_name=~"$host", device!="lo"}[1h])) or sum(increase(rdsosmetrics_network_tx{node_name=~"$host", device!="lo"}[1h]))',
        interval='1h',
        intervalFactor=1,
        legendFormat='Sent',
        calculatedInterval='2s',
        step=3600,
      )
  )
  .addTarget(
      prometheus.target(
        '(sum(increase(node_network_receive_bytes_total{node_name=~"$host", device!="lo"}[1h]))+sum(increase(node_network_transmit_bytes_total{node_name=~"$host", device!="lo"}[1h])))  or (sum(increase(rdsosmetrics_network_rx{node_name=~"$host", device!="lo"}[1h]))+sum(increase(rdsosmetrics_network_tx{node_name=~"$host", device!="lo"}[1h])))',
        interval='1h',
        intervalFactor=1,
        legendFormat='Total',
      )
  ),
  gridPos={
    "h": 7,
     "w": 12,
     "x": 12,
     "y": 51,
  },
  style=null,
)//22 graph
.addPanel(
  graphPanel.new(
    'Local Network Errors',//title
    description='Total Number of Local Network Interface Transmit Errors, Receive Errors and Drops.  Should be  Zero',
    decimals=2,
    fill=6,
    linewidth=2,
    bars=true,
    lines=false,
    points=true,
    datasource='Prometheus',
    pointradius=1,
    paceLength=10,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    legend_sort='avg',
    legend_sortDesc=true,
    editable=true,
    stack=true,
    min=0,
    formatY1='ops',
    formatY2='bytes',
    aliasColors={
        "Receive Drop": "#ef843c",
        "Receive Errors": "#890f02",
        "Transmit Drop": "#c15c17",
        "Transmit Errors": "#e24d42"
      },
  )
  .addTarget(
      prometheus.target(
        'sum(rate(node_network_receive_errs_total{node_name=~"$host", device!="lo"}[$interval])) or
        sum(irate(node_network_receive_errs_total{node_name=~"$host", device!="lo"}[5m]))',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Receive Errors',
        calculatedInterval='2s',
        step=3600,
      )
  )
  .addTarget(
      prometheus.target(
        'sum(rate(node_network_transmit_errs_total{node_name=~"$host", device!="lo"}[$interval])) or
        sum(irate(node_network_transmit_errs_total{node_name=~"$host", device!="lo"}[5m]))',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Transmit Errors',
      )
  )
  .addTarget(
      prometheus.target(
        'sum(rate(node_network_receive_drop_total{node_name=~"$host", device!="lo"}[$interval])) or
        sum(irate(node_network_receive_drop_total{node_name=~"$host", device!="lo"}[5m]))',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Receive Drop',
      )
  )
  .addTarget(
      prometheus.target(
        'sum(rate(node_network_transmit_drop_total{node_name=~"$host", device!="lo"}[$interval])) or
        sum(irate(node_network_transmit_drop_total{node_name=~"$host", device!="lo"}[5m]))',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Transmit Drop',
      )
  ),
  gridPos={
      "h": 7,
      "w": 12,
      "x": 0,
      "y": 58,
  },
  style=null,
)//52 graph
.addPanel(
  graphPanel.new(
    'TCP Retransmission',//title
    decimals=2,
    fill=2,
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
    editable=true,
    decimalsY1=2,
    decimalsY2=2,
    minY2=0,
    formatY1='ops',
    formatY2='percentunit',
    aliasColors={
        "Segments Retransmitted": "#bf1b00"
      },
  )
  .addSeriesOverride(
    {
        "alias": "Outbound",
        "transform": "negative-Y"
      }
  )
  .addSeriesOverride(
    {
         "alias": "Retransmit Ratio",
         "lines": false,
         "pointradius": 1,
         "points": true,
         "yaxis": 2
       }
  )
  .addTarget(
      prometheus.target(
        'rate(node_netstat_Tcp_RetransSegs{node_name=~"$host"}[$interval]) or irate(node_netstat_Tcp_RetransSegs{node_name=~"$host"}[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Segments Retransmitted',
        calculatedInterval='2s',
        step=300,
      )
  )
  .addTarget(
      prometheus.target(
        'rate(node_netstat_Tcp_RetransSegs{node_name=~"$host"}[$interval])/rate(node_netstat_Tcp_OutSegs{node_name=~"$host"}[$interval]) or irate(node_netstat_Tcp_RetransSegs{node_name=~"$host"}[5m])/irate(node_netstat_Tcp_OutSegsSegs{node_name=~"$host"}[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Retransmit Ratio',
      )
  ),
  gridPos={
      "h": 7,
      "w": 12,
      "x": 12,
      "y": 58,
  },
  style=null,
)//53 graph
