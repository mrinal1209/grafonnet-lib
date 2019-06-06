local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local graphPanel = grafana.graphPanel;
local annotation = grafana.annotation;
local text = grafana.text;
local template = grafana.template;
local timepicker = grafana.timepicker;
local prometheus = grafana.prometheus;
local row = grafana.row;
local pmmSinglestat = grafana.pmmSinglestat;
dashboard.new(
  'CPU Utilization Details (Cores)',
  time_from='now-12h',
  editable=true,
  refresh= "1m",
  graphTooltip='shared_crosshair',
  schemaVersion=16,
  version=1,
  tags=['OS','Percona'],
  iteration=1535381370089,
  uid="hCWR9oimz",
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
    tags = ['pmm_annotation'],
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
    url='/graph/dashboard/db/_pmm-query-analytics',
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
    'Cloud',
    ['Cloud'],
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
  current='Node-1.us',
  refresh='load',
  sort=1,
  allFormat='pipe',
  multiFormat='pipe',
  definition='label_values(node_boot_time_seconds, node_name)',
  skipUrlSync=false,
  ),
)
.addTemplate(
  template.new(
  'cpu',
  'Prometheus',
  'label_values(node_cpu_seconds_total{node_name=~\"$host\"}, cpu)',
  label='CPU',
  refresh='load',
  sort=3,
  includeAll=true,
  multi=true,
  hide=2,
  ),
)
.addPanel(
    row.new(
      title='',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 0,
    },
    style=null,
)//79
.addPanel(
  graphPanel.new(
  '$host - Overall CPU Utilization',//title
  fill=5,
  linewidth=1,
  datasource='Prometheus',
  pointradius=5,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  legend_rightSide=false,
  legend_hideEmpty=true,
  legend_hideZero=true,
  legend_sort="avg",
  legend_sortDesc=true,
  editable=true,
  formatY1 = 'percent',
  formatY2 = 'short',
  max = 100,
  min = 0,
  stack=true,
  aliasColors= {
   "Max Core Utilization": "#bf1b00",
   "idle": "#806EB7",
   "iowait": "#e0752d",
   "nice": "#1F78C1",
   "softirq": "#806EB7",
   "system": "#EAB839",
   "user": "#508642",
  },
  )
  .addSeriesOverride(
    {
        "alias": "Max Core Utilization",
        "lines": false,
        "pointradius": 1,
        "points": true,
        "stack": false
     }
  )
  .addTarget(
    prometheus.target(
    'clamp_max(((avg by (mode) ( (clamp_max(rate(node_cpu_seconds_total{node_name=~\"$host\",mode!=\"idle\"}[$interval]),1)) or (clamp_max(irate(node_cpu_seconds_total{node_name=~\"$host\",mode!=\"idle\"}[5m]),1)) ))*100 or (max_over_time(node_cpu_average{node_name=~\"$host\", mode!=\"total\", mode!=\"idle\"}[$interval]) or max_over_time(node_cpu_average{node_name=~\"$host\", mode!=\"total\", mode!=\"idle\"}[5m]))),100)',
    intervalFactor = 1,
    legendFormat='{{mode}}',
    refId='A',
    interval='$interval',
    calculatedInterval='2s',
    step=300,
    hide=false,
    )
  )
  .addTarget(
    prometheus.target(
    'clamp_max(max by () ((sum  by (cpu) ( (clamp_max(rate(node_cpu_seconds_total{node_name=~\"$host\",mode!=\"idle\",mode!=\"iowait\"}[$interval]),1)) or (clamp_max(irate(node_cpu_seconds_total{node_name=~\"$host\",mode!=\"idle\",mode!=\"iowait\"}[5m]),1)) )*100) or (max_over_time(node_cpu_average{node_name=~\"$host\", mode!=\"total\", mode!=\"idle\", mode!=\"wait\"}[$interval]) or max_over_time(node_cpu_average{node_name=~\"$host\", mode!=\"total\",mode!=\"idle\", mode!=\"wait\"}[5m]))),100)',
    intervalFactor = 1,
    legendFormat='Max Core Utilization',
    refId='B',
    interval='$interval',
    hide=false,
    )
  ),gridPos={
  x: 0,
  y: 1,
  w: 24,
  h: 8,
  },style=null,
)//22
.addPanel(
  graphPanel.new(
  '$host - Current CPU Core Utilization',//title
  fill=6,
  linewidth=2,
  datasource='Prometheus',
  pointradius=5,
  lines=false,
  legend_values=true,
  legend_min=true,
  legend_max=true,
  legend_avg=true,
  legend_alignAsTable=true,
  legend_rightSide=false,
  legend_hideEmpty=true,
  legend_hideZero=true,
  legend_show=false,
  legend_sortDesc=true,
  editable=true,
  aliasColors={
  "Avg": "#629e51",
  "cpu0": "#65c5db",
  "cpu1": "#65c5db",
  "cpu2": "#65c5db",
  "cpu3": "#65c5db",
  "cpu5": "#65c5db",
  "cpu6": "#65c5db",
  "idle": "#806EB7",
  "iowait": "#E24D42",
  "nice": "#1F78C1",
  "softirq": "#806EB7",
  "system": "#EAB839",
  "user": "#508642",
  },
  bars=true,
  formatY1 = 'percent',
  formatY2 = 'short',
  shared_tooltip=false,
  x_axis_mode='series',
  x_axis_values = 'current',
  )
  .addSeriesOverride(
    {
      "alias": "/^ /",
      "color": "#6ed0e0",
     }
  )
  .addTarget(
    prometheus.target(
      'clamp_max(avg by () ((sum by (cpu) ( (clamp_max(irate(node_cpu_seconds_total{node_name=~\"$host\",mode!=\"idle\",mode!=\"iowait\"}[5m]),1))*100 )) or max_over_time(node_cpu_average{node_name=~\"$host\", mode!=\"total\",mode!=\"idle\", mode!=\"wait\"}[5m])) ,100)',
      intervalFactor = 1,
      legendFormat='Avg',
      refId='B',
      interval='$interval',
      hide=false,
      instant=true,
    )
  )
  .addTarget(
    prometheus.target(
      'clamp_max((sum by (cpu) ( (clamp_max(irate(node_cpu_seconds_total{node_name=~\"$host\",mode!=\"idle\",mode!=\"iowait\"}[5m])*100,100)) )) or sum by (cpu) (max_over_time(node_cpu_average{node_name=~\"$host\", mode!=\"total\",mode!=\"idle\", mode!=\"wait\"}[5m])) ,100)',
      intervalFactor = 1,
      legendFormat='{{cpu}}',
      refId='A',
      interval='$interval',
      calculatedInterval='2s',
      step=300,
      instant=true,
   )
  ),gridPos={
  x: 0,
  y: 9,
  w: 24,
  h: 8,
  },style=null,
)//78
.addPanel(
    row.new(
      title='Overall CPU Utilization Details',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 17,
    },
    style=null,
)//80
.addPanel(
  pmmSinglestat.new(
    'All Cores - total',//title
    format='percent',
    datasource='Prometheus',
    valueName='current',
    colorValue=true,
    thresholds='70,90',
    sparklineShow=true,
  )
  .addTarget(
    prometheus.target(
      'clamp_max(sum by () ((avg by (mode) ( \n(clamp_max(rate(node_cpu_seconds_total{node_name=~\"$host\",mode!=\"idle\",mode!=\"iowait\"}[$interval]),1)) or \n(clamp_max(irate(node_cpu_seconds_total{node_name=~\"$host\",mode!=\"idle\",mode!=\"iowait\"}[5m]),1)) )) *100 or \nsum by () (\navg_over_time(node_cpu_average{node_name=~\"$host\",mode!=\"total\",mode!=\"idle\"}[$interval]) or \navg_over_time(node_cpu_average{node_name=~\"$host\",mode!=\"total\",mode!=\"idle\"}[5m])) unless\n(avg_over_time(node_cpu_average{node_name=~\"$host\",mode=\"total\",job=\"rds-basic\"}[$interval]) or \navg_over_time(node_cpu_average{node_name=~\"$host\",mode=\"total\",job=\"rds-basic\"}[5m]))\n),100)',
      intervalFactor = 1,
      legendFormat='',
      refId='A',
      interval='$interval',
    )
  ),
  gridPos = {
     "h": 3,
     "w": 4,
     "x": 0,
     "y": 18,
  },
  style=null,
)//29
.addPanel(
  pmmSinglestat.new(
    'All Cores - user',//title
    format='percent',
    datasource='Prometheus',
    valueName='current',
    colorValue=true,
    thresholds='70,90',
    sparklineShow=true,
  )
  .addTarget(
    prometheus.target(
      'clamp_max(((avg by (mode) ( (clamp_max(rate(node_cpu_seconds_total{node_name=~\"$host\",mode=\"user\"}[$interval]),1)) or (clamp_max(irate(node_cpu_seconds_total{node_name=~\"$host\",mode=\"user\"}[5m]),1)) )) *100 or (avg_over_time(node_cpu_average{node_name=~\"$host\", mode=\"user\"}[$interval]) or avg_over_time(node_cpu_average{node_name=~\"$host\", mode=\"user\"}[5m]))),100)',
      intervalFactor = 1,
      refId='A',
      interval='$interval',
    )
  ),
  gridPos = {
     "h": 3,
     "w": 4,
     "x": 4,
     "y": 18,
  },
  style=null,
)//30
.addPanel(
  pmmSinglestat.new(
    'All Cores - system',//title
    format='percent',
    datasource='Prometheus',
    valueName='current',
    colorValue=true,
    thresholds='20,30',
    sparklineShow=true,
  )
  .addTarget(
    prometheus.target(
      'clamp_max(((avg by (mode) ( (clamp_max(rate(node_cpu_seconds_total{node_name=~\"$host\",mode=\"system\"}[$interval]),1)) or (clamp_max(irate(node_cpu_seconds_total{node_name=~\"$host\",mode=\"system\"}[5m]),1)) )) *100 or (avg_over_time(node_cpu_average{node_name=~\"$host\", mode=\"system\"}[$interval]) or avg_over_time(node_cpu_average{node_name=~\"$host\", mode=\"system\"}[5m]))),100)',
      intervalFactor = 1,
      refId='A',
      interval='$interval',
    )
  ),
  gridPos = {
     "h": 3,
     "w": 4,
     "x": 8,
     "y": 18,
  },
  style=null,
)//31
.addPanel(
  pmmSinglestat.new(
    'All Cores - iowait',//title
    format='percent',
    datasource='Prometheus',
    valueName='current',
    colorValue=true,
    thresholds='20,50',
    sparklineShow=true,
  )
  .addTarget(
    prometheus.target(
      'clamp_max(((avg by (mode) ( (clamp_max(rate(node_cpu_seconds_total{node_name=~\"$host\",mode=\"iowait\"}[$interval]),1)) or (clamp_max(irate(node_cpu_seconds_total{node_name=~\"$host\",mode=\"iowait\"}[5m]),1)) )) *100 or (avg_over_time(node_cpu_average{node_name=~\"$host\", mode=\"wait\"}[$interval]) or avg_over_time(node_cpu_average{node_name=~\"$host\", mode=\"wait\"}[5m]))),100)',
      intervalFactor = 1,
      refId='A',
      interval='$interval',
    )
  ),
  gridPos = {
    "h": 3,
    "w": 4,
    "x": 12,
    "y": 18,
  },
  style=null,
)//32
.addPanel(
  pmmSinglestat.new(
    'All Cores - steal',//title
    format='percent',
    datasource='Prometheus',
    valueName='current',
    colorValue=true,
    thresholds='10,30',
    sparklineShow=true,
  )
  .addTarget(
    prometheus.target(
      'clamp_max(((avg by (mode) ( (clamp_max(rate(node_cpu_seconds_total{node_name=~\"$host\",mode=\"steal\"}[$interval]),1)) or (clamp_max(irate(node_cpu_seconds_total{node_name=~\"$host\",mode=\"steal\"}[5m]),1)) )) *100 or (avg_over_time(node_cpu_average{node_name=~\"$host\", mode=\"steal\"}[$interval]) or avg_over_time(node_cpu_average{node_name=~\"$host\", mode=\"steal\"}[5m]))),100)',
      intervalFactor = 1,
      refId='A',
      interval='$interval',
    )
  ),
  gridPos = {
        "h": 3,
        "w": 4,
        "x": 16,
        "y": 18,
  },
  style=null,
)//33
.addPanel(
  pmmSinglestat.new(
    'All Cores - other',//title
    format='percent',
    datasource='Prometheus',
    valueName='current',
    colorValue=true,
    thresholds='10,20',
    sparklineShow=true,
  )
  .addTarget(
    prometheus.target(
      'clamp_max(((sum by () (avg by (mode) ( (clamp_max(rate(node_cpu_seconds_total{node_name=~\"$host\",mode!=\"idle\",mode!=\"user\",mode!=\"system\",mode!=\"iowait\",mode!=\"steal\"}[$interval]),1)) or (clamp_max(irate(node_cpu_seconds_total{node_name=~\"$host\",mode!=\"idle\",mode!=\"user\",mode!=\"system\",mode!=\"iowait\",mode!=\"steal\"}[5m]),1)) )) *100) or (sum(avg_over_time(node_cpu_average{node_name=~\"$host\", mode!=\"total\",mode!=\"idle\",mode!=\"user\",mode!=\"system\",mode!=\"wait\",mode!=\"steal\"}[$interval])) or sum(avg_over_time(node_cpu_average{node_name=~\"$host\", mode!=\"total\",mode!=\"idle\",mode!=\"user\",mode!=\"system\",mode!=\"wait\",mode!=\"steal\"}[5m])))),100)',
      intervalFactor = 1,
      refId='A',
      interval='$interval',
    )
  ),
  gridPos = {
  "h": 3,
  "w": 4,
  "x": 20,
  "y": 18,
  },
  style=null,
)//34
.addPanel(
    row.new(
      title='CPU Cores Utilization Details',
      collapse = true,
    )
    .addPanel(
        text.new(
          title = 'Per Core CPU Usage',
          content = 'Per CPU usage Information shows  usage for each CPU (Virtual) core.  The Current (most recent) numbers are shown together with history as sparkline',
        ),
        gridPos= {
            "h": 3,
            "w": 24,
            "x": 0,
            "y": 22,
          }
    ),
    gridPos={
    "h": 1,
    "w": 24,
    "x": 0,
    "y": 21,
    },
    style=null,
)//81
.addPanel(
    row.new(
      title='$cpu',
      repeat='cpu',
    ),
    gridPos={
    "h": 1,
    "w": 24,
    "x": 0,
    "y": 22,
    },
    style=null,
)//82
.addPanel(
  pmmSinglestat.new(
    '$cpu - total',//title
    format='percent',
    datasource='Prometheus',
    valueName='current',
    colorValue=true,
    thresholds='70,90',
    sparklineShow=true,
  )
  .addTarget(
    prometheus.target(
      'clamp_max(\nsum by (cpu) (\n(avg by (mode) ( (clamp_max(rate(node_cpu_seconds_total{node_name=~\"$host\",cpu=\"$cpu\",mode!=\"idle\",mode!=\"iowait\"}[$interval]),1)) or \n(clamp_max(irate(node_cpu_seconds_total{node_name=~\"$host\",cpu=\"$cpu\",mode!=\"idle\",mode!=\"iowait\"}[5m]),1)) )) *100) or \nsum by () (\navg_over_time(node_cpu_average{node_name=~\"$host\",mode!=\"total\",mode!=\"idle\"}[$interval]) or \navg_over_time(node_cpu_average{node_name=~\"$host\",mode!=\"total\",mode!=\"idle\"}[5m])) unless\n(avg_over_time(node_cpu_average{node_name=~\"$host\",mode=\"total\",job=\"rds-basic\"}[$interval]) or \navg_over_time(node_cpu_average{node_name=~\"$host\",mode=\"total\",job=\"rds-basic\"}[5m]))\n,100)',
      intervalFactor = 1,
      refId='A',
      interval='$interval',
      instant=false,
      legendFormat='',
    )
  ),
  gridPos = {
     "h": 3,
     "w": 4,
     "x": 0,
     "y": 23,
  },
  style=null,
)//26
.addPanel(
  pmmSinglestat.new(
    '$cpu - user',//title
    format='percent',
    datasource='Prometheus',
    valueName='current',
    colorValue=true,
    thresholds='70,90',
    sparklineShow=true,
  )
  .addTarget(
    prometheus.target(
      'clamp_max(((avg by (mode) ( (clamp_max(rate(node_cpu_seconds_total{node_name=~\"$host\",cpu=\"$cpu\",mode=\"user\"}[$interval]),1)) or (clamp_max(irate(node_cpu_seconds_total{node_name=~\"$host\",cpu=\"$cpu\",mode=\"user\"}[5m]),1)) )) *100 or (avg_over_time(node_cpu_average{node_name=~\"$host\", cpu=\"All\", mode=\"user\"}[$interval]) or avg_over_time(node_cpu_average{node_name=~\"$host\", cpu=\"All\", mode=\"user\"}[5m]))),100)',
      intervalFactor = 1,
      refId='A',
      interval='$interval',
    )
  ),
  gridPos = {
     "h": 3,
     "w": 4,
     "x": 4,
     "y": 23,
  },
  style=null,
)//23
.addPanel(
  pmmSinglestat.new(
    '$cpu - system',//title
    format='percent',
    datasource='Prometheus',
    valueName='current',
    colorValue=true,
    thresholds='20,30',
    sparklineShow=true,
  )
  .addTarget(
    prometheus.target(
      'clamp_max(((avg by (mode) ( (clamp_max(rate(node_cpu_seconds_total{node_name=~\"$host\",cpu=\"$cpu\",mode=\"system\"}[$interval]),1)) or (clamp_max(irate(node_cpu_seconds_total{node_name=~\"$host\",cpu=\"$cpu\",mode=\"system\"}[5m]),1)) )) *100 or (avg_over_time(node_cpu_average{node_name=~\"$host\", cpu=\"All\", mode=\"system\"}[$interval]) or avg_over_time(node_cpu_average{node_name=~\"$host\", cpu=\"All\", mode=\"system\"}[5m]))),100)',
      intervalFactor = 1,
      refId='A',
      interval='$interval',
    )
  ),
  gridPos = {
     "h": 3,
     "w": 4,
     "x": 8,
     "y": 23,
  },
  style=null,
)//24
.addPanel(
  pmmSinglestat.new(
    '$cpu - iowait',//title
    format='percent',
    datasource='Prometheus',
    valueName='current',
    colorValue=true,
    thresholds='20,50',
    sparklineShow=true,
  )
  .addTarget(
    prometheus.target(
      'clamp_max(((avg by (mode) ( (clamp_max(rate(node_cpu_seconds_total{node_name=~\"$host\",cpu=\"$cpu\",mode=\"iowait\"}[$interval]),1)) or (clamp_max(irate(node_cpu_seconds_total{node_name=~\"$host\",cpu=\"$cpu\",mode=\"iowait\"}[5m]),1)) )) *100 or (avg_over_time(node_cpu_average{node_name=~\"$host\", cpu=\"All\", mode=\"wait\"}[$interval]) or avg_over_time(node_cpu_average{node_name=~\"$host\", cpu=\"All\", mode=\"wait\"}[5m]))),100)',
      intervalFactor = 1,
      refId='A',
      interval='$interval',
    )
  ),
  gridPos = {
     "h": 3,
     "w": 4,
     "x": 12,
     "y": 23,
  },
  style=null,
)//25
.addPanel(
  pmmSinglestat.new(
    '$cpu - steal',//title
    format='percent',
    datasource='Prometheus',
    valueName='current',
    colorValue=true,
    thresholds='10,30',
    sparklineShow=true,
  )
  .addTarget(
    prometheus.target(
      'clamp_max(((avg by (mode) ( (clamp_max(rate(node_cpu_seconds_total{node_name=~\"$host\",cpu=\"$cpu\",mode=\"steal\"}[$interval]),1)) or (clamp_max(irate(node_cpu_seconds_total{node_name=~\"$host\",cpu=\"$cpu\",mode=\"steal\"}[5m]),1)) )) *100 or (avg_over_time(node_cpu_average{node_name=~\"$host\", cpu=\"All\", mode=\"steal\"}[$interval]) or avg_over_time(node_cpu_average{node_name=~\"$host\", cpu=\"All\", mode=\"steal\"}[5m]))),100)',
      intervalFactor = 1,
      refId='A',
      interval='$interval',
    )
  ),
  gridPos = {
     "h": 3,
     "w": 4,
     "x": 16,
     "y": 23,
  },
  style=null,
)//27
.addPanel(
  pmmSinglestat.new(
    '$cpu - other',//title
    format='percent',
    datasource='Prometheus',
    valueName='current',
    colorValue=true,
    thresholds='10,20',
    sparklineShow=true,
  )
  .addTarget(
    prometheus.target(
      'clamp_max(((sum by (instance) (avg by (mode) ( (clamp_max(rate(node_cpu_seconds_total{node_name=~\"$host\",cpu=\"$cpu\",mode!=\"idle\",mode!=\"user\",mode!=\"system\",mode!=\"iowait\",mode!=\"steal\"}[$interval]),1)) or (clamp_max(irate(node_cpu_seconds_total{node_name=~\"$host\",cpu=\"$cpu\",mode!=\"idle\",mode!=\"user\",mode!=\"system\",mode!=\"iowait\",mode!=\"steal\"}[5m]),1)) )) *100) or (sum(avg_over_time(node_cpu_average{node_name=~\"$host\", cpu=\"All\",mode!=\"total\",mode!=\"idle\",mode!=\"user\",mode!=\"system\",mode!=\"wait\",mode!=\"steal\"}[$interval])) or sum(avg_over_time(node_cpu_average{node_name=~\"$host\",cpu=\"All\",mode!=\"total\",mode!=\"idle\",mode!=\"user\",mode!=\"system\",mode!=\"wait\",mode!=\"steal\"}[5m])))),100)',
      intervalFactor = 1,
      refId='A',
      interval='$interval',
    )
  ),
  gridPos = {
     "h": 3,
     "w": 4,
     "x": 20,
     "y": 23,
  },
  style=null,
)//28
