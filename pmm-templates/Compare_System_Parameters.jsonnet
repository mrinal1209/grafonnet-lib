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
  'Compare System Parameters',
  time_from='now-12h',
  editable=false,
  refresh= "1m",
  graphTooltip='shared_crosshair',
  schemaVersion=18,
  version=18,
  tags=['OS','Percona'],
  iteration=1553870190718,
  uid="000000205",
  gnetId=405,
  description='Dashboard to view multiple servers',
  timepicker = timepicker.new(
    hidden=false,
    now=true,
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
  sort=1,
  allFormat='glob',
  multiFormat='regex values',
  multi=true,
  skipUrlSync=false,
  definition='label_values(node_boot_time_seconds, node_name)',
  includeAll=true,
  ),
)
.addPanel(
  text.new(
    content='<h1><i><font color=#5991A7><b><center>System Information</center></b></font></i></h1>',
    height='15px',
    mode='html',
    transparent=true,
  ),
  gridPos={
        "h": 2,
        "w": 24,
        "x": 0,
        "y": 0,
      },
  style=null,
)//98 text
.addPanel(
    row.new(
      title='',
    ),
    gridPos={
    "h": 1,
    "w": 24,
    "x": 0,
    "y": 2,
    },
    style=null,
)//234 row
.addPanel(
  tablePanel.new(
    title='$host - System Info',
    datasource='Prometheus',
    fontSize='100%',
    maxPerRow=6,
    repeat='host',
    repeatDirection='h',
    scroll=true,
    showHeader=true,
    sort={
      "col":0,
      "desc":true,
    },
  )
  .addStyle(
        {
          "alias": "Time",
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "pattern": "Time",
          "type": "hidden",
        },
  )
  .addStyle(
  {
  "alias": "",
  "colorMode": null,
  "colors": [
    "rgba(245, 54, 54, 0.9)",
    "rgba(237, 129, 40, 0.89)",
    "rgba(50, 172, 45, 0.97)"
  ],
  "dateFormat": "YYYY-MM-DD HH:mm:ss",
  "decimals": 2,
  "mappingType": 1,
  "pattern": "__name__",
  "thresholds": [],
  "type": "hidden",
  "unit": "short",
  },
  )
  .addStyle(
  {
       "alias": "Domain",
       "colorMode": null,
       "colors": [
         "rgba(245, 54, 54, 0.9)",
         "rgba(237, 129, 40, 0.89)",
         "rgba(50, 172, 45, 0.97)"
       ],
       "dateFormat": "YYYY-MM-DD HH:mm:ss",
       "decimals": 2,
       "mappingType": 1,
       "pattern": "domainname",
       "thresholds": [],
       "type": "number",
       "unit": "short",
     },
  )
  .addStyle(
      {
          "alias": "",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "instance",
          "thresholds": [],
          "type": "hidden",
          "unit": "short",
        },
  )
  .addStyle(
  {
      "alias": "",
      "colorMode": null,
      "colors": [
        "rgba(245, 54, 54, 0.9)",
        "rgba(237, 129, 40, 0.89)",
        "rgba(50, 172, 45, 0.97)"
      ],
      "dateFormat": "YYYY-MM-DD HH:mm:ss",
      "decimals": 2,
      "mappingType": 1,
      "pattern": "job",
      "thresholds": [],
      "type": "hidden",
      "unit": "short",
    },
  )
  .addStyle(
      {
          "alias": "",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "machine",
          "thresholds": [],
          "type": "hidden",
          "unit": "short",
        },
  )
  .addStyle(
  {
      "alias": "Nodename",
      "colorMode": "value",
      "colors": [
        "rgba(245, 54, 54, 0.9)",
        "rgba(237, 129, 40, 0.89)",
        "rgba(50, 172, 45, 0.97)"
      ],
      "dateFormat": "YYYY-MM-DD HH:mm:ss",
      "decimals": 2,
      "mappingType": 1,
      "pattern": "nodename",
      "sanitize": true,
      "thresholds": [],
      "type": "string",
      "unit": "short",
    },
  )
  .addStyle(
  {
         "alias": "Kernel",
         "colorMode": null,
         "colors": [
           "rgba(245, 54, 54, 0.9)",
           "rgba(237, 129, 40, 0.89)",
           "rgba(50, 172, 45, 0.97)"
         ],
         "dateFormat": "YYYY-MM-DD HH:mm:ss",
         "decimals": 2,
         "mappingType": 1,
         "pattern": "release",
         "thresholds": [],
         "type": "number",
         "unit": "short",
       },
  )
  .addStyle(
  {
         "alias": "System",
         "colorMode": null,
         "colors": [
           "rgba(245, 54, 54, 0.9)",
           "rgba(237, 129, 40, 0.89)",
           "rgba(50, 172, 45, 0.97)"
         ],
         "dateFormat": "YYYY-MM-DD HH:mm:ss",
         "decimals": 2,
         "mappingType": 1,
         "pattern": "sysname",
         "thresholds": [],
         "type": "number",
         "unit": "short"
       },
  )
  .addStyle(
  {
     "alias": "",
     "colorMode": null,
     "colors": [
       "rgba(245, 54, 54, 0.9)",
       "rgba(237, 129, 40, 0.89)",
       "rgba(50, 172, 45, 0.97)"
     ],
     "dateFormat": "YYYY-MM-DD HH:mm:ss",
     "decimals": 2,
     "mappingType": 1,
     "pattern": "version",
     "thresholds": [],
     "type": "hidden",
     "unit": "short",
   },
  )
  .addStyle(
        {
            "alias": "",
            "colorMode": null,
            "colors": [
              "rgba(245, 54, 54, 0.9)",
              "rgba(237, 129, 40, 0.89)",
              "rgba(50, 172, 45, 0.97)"
            ],
            "dateFormat": "YYYY-MM-DD HH:mm:ss",
            "decimals": 2,
            "mappingType": 1,
            "pattern": "Value",
            "thresholds": [],
            "type": "hidden",
            "unit": "short",
          },
  )
  .addStyle(
  {
    "alias": "",
    "colorMode": null,
    "colors": [
      "rgba(245, 54, 54, 0.9)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(50, 172, 45, 0.97)"
    ],
    "decimals": 2,
    "pattern": "az",
    "thresholds": [],
    "type": "hidden",
    "unit": "short",
  },
  )
  .addStyle(
  {
           "alias": "",
           "colorMode": null,
           "colors": [
             "rgba(245, 54, 54, 0.9)",
             "rgba(237, 129, 40, 0.89)",
             "rgba(50, 172, 45, 0.97)"
           ],
           "dateFormat": "YYYY-MM-DD HH:mm:ss",
           "decimals": 2,
           "mappingType": 1,
           "pattern": "machine_id",
           "thresholds": [],
           "type": "hidden",
           "unit": "short",
         },
  )
  .addStyle(
  {
     "alias": "",
     "colorMode": null,
     "colors": [
       "rgba(245, 54, 54, 0.9)",
       "rgba(237, 129, 40, 0.89)",
       "rgba(50, 172, 45, 0.97)"
     ],
     "dateFormat": "YYYY-MM-DD HH:mm:ss",
     "decimals": 2,
     "mappingType": 1,
     "pattern": "custom_label",
     "thresholds": [],
     "type": "hidden",
     "unit": "short",
   },
  )
  .addStyle(
  {
          "alias": "",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "node_id",
          "thresholds": [],
          "type": "hidden",
          "unit": "short",
        },
  )
  .addStyle(
  {
      "alias": "",
      "colorMode": null,
      "colors": [
        "rgba(245, 54, 54, 0.9)",
        "rgba(237, 129, 40, 0.89)",
        "rgba(50, 172, 45, 0.97)"
      ],
      "dateFormat": "YYYY-MM-DD HH:mm:ss",
      "decimals": 2,
      "mappingType": 1,
      "pattern": "node_name",
      "thresholds": [],
      "type": "hidden",
      "unit": "short",
    },
  )
  .addStyle(
  {
     "alias": "",
     "colorMode": null,
     "colors": [
       "rgba(245, 54, 54, 0.9)",
       "rgba(237, 129, 40, 0.89)",
       "rgba(50, 172, 45, 0.97)"
     ],
     "dateFormat": "YYYY-MM-DD HH:mm:ss",
     "decimals": 2,
     "mappingType": 1,
     "pattern": "node_type",
     "thresholds": [],
     "type": "hidden",
     "unit": "short",
   },
  )
  .addStyle(
  {
      "alias": "",
      "colorMode": null,
      "colors": [
        "rgba(245, 54, 54, 0.9)",
        "rgba(237, 129, 40, 0.89)",
        "rgba(50, 172, 45, 0.97)"
      ],
      "dateFormat": "YYYY-MM-DD HH:mm:ss",
      "decimals": 2,
      "mappingType": 1,
      "pattern": "region",
      "thresholds": [],
      "type": "hidden",
      "unit": "short",
    },
  )
  .addTarget(
    prometheus.target(
      'node_uname_info{node_name=~"$host"}',
      intervalFactor = 1,
      refId='A',
      interval='1h',
      instant=true,
      format='table',
   )
   ),
  gridPos={
      "h": 3,
      "w": 12,
      "x": 0,
      "y": 3,
    },
    style=null,
)//428 table
.addPanel(
    row.new(
      title='',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 6,
    },
    style=null,
)//236 row
.addPanel(
  singlestat.new(
    '$host - System Uptime',//title
    format='s',
    datasource='Prometheus',
    valueName='current',
    decimals=1,
    colorValue=true,
    thresholds='300,3600',
    maxPerRow=6,
    colors=[
      '#d44a3a',
      'rgba(237, 129, 40, 0.89)',
      '#299c46',
    ],
    height='100px',
    links=[
            {
                "dashboard": "System Overview",
                "dashUri": "db/system-overview",
                "includeVars": true,
                "keepTime": true,
                "targetBlank": true,
                "title": "System Overview",
                "type": "dashboard"
            }
    ],
    repeat='host',
    repeatDirection='h',
    valueMaps=[],
  )
  .addTarget(
    prometheus.target(
      'node_time_seconds{node_name=~"$host"} - node_boot_time_seconds{node_name=~"$host"}',
      intervalFactor = 1,
      refId='A',
      interval='5m',
    )
  ),
  gridPos = {
  "h": 2,
  "w": 12,
  "x": 0,
  "y": 7,
  },
  style=null,
)//52 singlestat
.addPanel(
    row.new(
      title='',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 9,
    },
    style=null,
)//266 row
.addPanel(
  singlestat.new(
    '$host - CPU Cores',//title
    format='none',
    datasource='Prometheus',
    valueName='avg',
    thresholds='',
    repeat='host',
    maxPerRow=6,
    editable=true,
    colors=[
      "rgba(245, 54, 54, 0.9)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(50, 172, 45, 0.97)",
    ],
    links=[
    {
      "dashUri": "db/cpu-utilization-details-cores",
      "dashboard": "CPU Utilization Details (Cores)",
      "includeVars": true,
      "keepTime": true,
      "targetBlank": true,
      "title": "CPU Utilization Details (Cores)",
      "type": "dashboard",
    }
    ],
  )
  .addTarget(
    prometheus.target(
      'count(node_cpu_seconds_total{node_name=~"$host", mode="system"})',
      intervalFactor = 2,
      refId='A',
      interval='',
      step=14400,
    )
  ),
  gridPos = {
        "h": 2,
        "w": 12,
        "x": 0,
        "y": 10,
  },
  style=null,
)//20 singlestat
.addPanel(
    row.new(
      title='',
    ),
    gridPos={
      "h": 1,
      "w": 24,
      "x": 0,
      "y": 12,
    },
    style=null,
)//262 row
.addPanel(
  singlestat.new(
    '$host - RAM',//title
    format='bytes',
    datasource='Prometheus',
    valueName='current',
    thresholds='',
    maxPerRow=6,
    decimals=2,
    height='100px',
    links=[
            {
                "dashboard": "System Overview",
                "dashUri": "db/system-overview",
                "includeVars": true,
                "keepTime": true,
                "targetBlank": true,
                "title": "System Overview",
                "type": "dashboard"
            }
    ],
    repeat='host',
    prefixFontSize='80%',
  )
  .addTarget(
    prometheus.target(
      'node_memory_MemTotal_bytes{node_name=~"$host"}',
      intervalFactor = 1,
      refId='A',
      interval='5m',
    )
  ),
  gridPos = {
        "h": 2,
        "w": 12,
        "x": 0,
        "y": 13,
  },
  style=null,
)//80 singlestat
.addPanel(
    row.new(
      title='',
    ),
    gridPos={
     "h": 1,
     "w": 24,
     "x": 0,
     "y": 15,
    },
    style=null,
)//260 row
.addPanel(
  graphPanel.new(
    '$host - Saturation Metrics',//title
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
    legend_rightSide=false,
    legend_hideEmpty=false,
    legend_show=true,
    legend_sortDesc=true,
    editable=true,
    maxPerRow=6,
    repeat='host',
    format='short',
    aliasColors={
      "Allocated": "#E0752D",
       "CPU Load": "#64B0C8",
       "IO Load ": "#EA6460",
       "Limit": "#1F78C1",
       "Normalized CPU Load": "#6ED0E0",
    },
    links=[
            {
                "dashboard": "System Overview",
                "dashUri": "db/system-overview",
                "includeVars": true,
                "keepTime": true,
                "targetBlank": true,
                "title": "System Overview",
                "type": "dashboard"
            }
    ],
    min=0,
  )
  .addTarget(
      prometheus.target(
        '(avg_over_time(node_procs_running{node_name=~"$host"}[$interval])-1) / scalar(count(node_cpu_seconds_total{mode="user", node_name=~"$host"})) or (avg_over_time(node_procs_running{node_name=~"$host"}[5m])-1) / scalar(count(node_cpu_seconds_total{mode="user", node_name=~"$host"}))',
        refId='B',
        interval='$interval',
        calculatedInterval='2s',
        step=300,
        intervalFactor=1,
        legendFormat='Normalized CPU Load'
      )
  )
  .addTarget(
      prometheus.target(
        'avg_over_time(node_procs_blocked{node_name=~"$host"}[$interval]) or avg_over_time(node_procs_blocked{node_name=~"$host"}[5m])',
        refId='A',
        interval='$interval',
        calculatedInterval='2s',
        step=300,
        legendFormat='IO Load ',
        intervalFactor=1,
      )
  ),
  gridPos={
        "h": 7,
        "w": 12,
        "x": 0,
        "y": 16,
  },
  style=null,
)//39 graph
.addPanel(
    row.new(
      title='',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 23,
    },
    style=null,
)//268 row
.addPanel(
  graphPanel.new(
    '$host - Load Average',//title
    fill=1,
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
    nullPointMode='connected',
    editable=true,
    maxPerRow=6,
    repeat='host',
    format='short',
    minY1=0,
    value_type="cumulative",
    aliasColors={
      "VCPUs": "#fce2de",
      "mdb101 1m": "#bf1b00",
    },
    links=[
            {
              "dashUri": "db/system-overview",
              "dashboard": "System Overview",
              "includeVars": true,
              "keepTime": true,
              "params": "panelId=18&fullscreen",
              "targetBlank": true,
              "title": "System Overview",
              "type": "dashboard",
            }
    ],
  )
  .addTarget(
      prometheus.target(
        'node_load1{node_name=~"$host"}',
        refId='A',
        interval='$interval',
        step=1200,
        intervalFactor=1,
        legendFormat='LoadAvg 1m'
      )
  )
  .addTarget(
      prometheus.target(
        'count(node_cpu_seconds_total{mode="user", node_name=~"$host"})',
        refId='B',
        interval='$interval',
        legendFormat='VCPUs',
        intervalFactor=1,
      )
  ),
  gridPos={
      "h": 7,
      "w": 12,
      "x": 0,
      "y": 24,
  },
  style=null,
)//13 graph
.addPanel(
    row.new(
      title='CPU',
    ),
    gridPos={
    "h": 1,
    "w": 24,
    "x": 0,
    "y": 31,
    },
    style=null,
)//272 row
.addPanel(
  text.new(
    content='<h1><i><font color=#5991A7><b><center>CPU</center></b></font></i></h1>',
    height='20px',
    mode='html',
    transparent=true,
  ),
  gridPos={
    "h": 2,
    "w": 24,
    "x": 0,
    "y": 32,
  },
  style=null,
)//99 text
.addPanel(
    row.new(
      title='',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 34,
    },
    style=null,
)//270 row
.addPanel(
  graphPanel.new(
    '$host - CPU Usage',//title
    fill=6,
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
    editable=true,
    stack=true,
    maxPerRow=6,
    repeat='host',
    decimalsY1=1,
    maxY1='1',
    minY1=0,
    aliasColors={
      "Max Core Utilization": "#bf1b00",
      "iowait": "#ef843c",
      "nice": "#9ac48a",
      "softirq": "#705da0",
      "system": "#e5ac0e",
      "user": "#508642",
    },
    links=[
            {
                "dashUri": "db/cpu-utilization-details-cores",
                "dashboard": "CPU Utilization Details (Cores)",
                "includeVars": true,
                "keepTime": true,
                "params": "&panelId=22&fullscreen",
                "targetBlank": true,
                "title": "CPU Utilization Details (Cores)",
                "type": "dashboard",
            }
    ],
    formatY1='percentunit',
    formatY2='short',
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
        'clamp_max((avg by (mode) ( (clamp_max(rate(node_cpu_seconds_total{node_name=~"$host",mode!="idle"}[$interval]),1)) or (clamp_max(irate(node_cpu_seconds_total{node_name=~"$host",mode!="idle"}[5m]),1)) )),1)',
        refId='A',
        interval='$interval',
        step=1200,
        intervalFactor=1,
        legendFormat='{{mode}}'
      )
  )
  .addTarget(
      prometheus.target(
        'clamp_max(max by () (sum  by (cpu) ( (clamp_max(rate(node_cpu_seconds_total{node_name=~"$host",mode!="idle",mode!="iowait"}[$interval]),1)) or (clamp_max(irate(node_cpu_seconds_total{node_name=~"$host",mode!="idle",mode!="iowait"}[5m]),1)) )),1)',
        refId='B',
        interval='$interval',
        legendFormat='Max Core Utilization',
        intervalFactor=1,
      )
  ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 35,
  },
  style=null,
)//7 graph
.addPanel(
    row.new(
      title='',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 42,
    },
    style=null,
)//335 row
.addPanel(
  graphPanel.new(
    '$host - Interrupts',//title
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
    editable=true,
    repeat='host',
    repeatDirection='h',
    maxPerRow=6,
    decimalsY1=2,
    minY1='0',
    aliasColors={
     "Interrupts": "#962d82",
     "Interrupts per VCPU": "#447ebc",
     },
    links=[
            {
            "dashUri": "db/system-overview",
            "dashboard": "System Overview",
            "includeVars": true,
            "keepTime": true,
            "params": "panelId=28&fullscreen",
            "targetBlank": true,
            "title": "System Overview",
            "type": "dashboard",
            }
     ],
  )
  .addTarget(
      prometheus.target(
        'rate(node_intr_total{node_name=~"$host"}[$interval]) or irate(node_intr_total{node_name=~"$host"}[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Interrupts',
      )
  )
  .addTarget(
      prometheus.target(
        '(rate(node_intr_total{node_name=~"$host"}[$interval]) or irate(node_intr_total{node_name=~"$host"}[5m])) /scalar(count(node_cpu_seconds_total{mode="user", node_name=~"$host"}))',
        interval='$interval',
        legendFormat='Interrupts per VCPU',
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
)//86 graph
.addPanel(
    row.new(
      title='',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 50,
    },
    style=null,
)//333 row
.addPanel(
  graphPanel.new(
    '$host - Context Switches',//title
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
    editable=true,
    repeat='host',
    maxPerRow=6,
    value_type='cumulative',
    links=[
            {
            "dashUri": "db/system-overview",
            "dashboard": "System Overview",
            "includeVars": true,
            "keepTime": true,
            "params": "panelId=27&fullscreen",
            "targetBlank": true,
            "title": "System Overview",
            "type": "dashboard",
            }
     ],
  )
  .addTarget(
      prometheus.target(
        'rate(node_context_switches_total{node_name=~"$host"}[$interval]) or irate(node_context_switches_total{node_name=~"$host"}[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Context Switches',
        step=1200,
      )
  )
  .addTarget(
      prometheus.target(
        '(rate(node_context_switches_total{node_name=~"$host"}[$interval]) or irate(node_context_switches_total{node_name=~"$host"}[5m])) / scalar(count(node_cpu_seconds_total{mode="user", node_name=~"$host"}))',
        interval='$interval',
        legendFormat='Context Switches per Virtual CPU',
        intervalFactor=1,
      )
  ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 51,
  },
  style=null,
)//22 graph
.addPanel(
    row.new(
      title='Memory',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 58,
    },
    style=null,
)//331 row
.addPanel(
  text.new(
    content='<h1><i><font color=#5991A7><b><center>Memory</center></b></font></i></h1>',
    height='20px',
    mode='html',
    transparent=true,
  ),
  gridPos={
        "h": 2,
        "w": 24,
        "x": 0,
        "y": 59,
      },
  style=null,
)//101 text
.addPanel(
    row.new(
      title='',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 61,
    },
    style=null,
)//329 row
.addPanel(
  graphPanel.new(
    '$host - Memory  Usage',//title
    fill=4,
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
    editable=true,
    repeat='host',
    maxPerRow=6,
    stack=true,
    nullPointMode='connected',
    decimalsY1=2,
    formatY1='bytes',
    labelY1='GB',
    minY1='0',
    aliasColors={
        "Buffers": "#bf1b00",
        "Free": "#9ac48a",
        "Slab": "#E5A8E2",
        "Swap": "#E24D42",
        "Used": "#1f78c1"
      },
    links=[
            {
            "dashUri": "db/system-overview",
            "dashboard": "System Overview",
            "includeVars": true,
            "keepTime": true,
            "params": "panelId=34&fullscreen",
            "targetBlank": true,
            "title": "System Overview",
            "type": "dashboard",
            }
     ],
  )
  .addSeriesOverride(
        {
          "alias": "/Apps|Buffers|Cached|Free|Slab|SwapCached|PageTables|VmallocUsed/",
          "fill": 5,
          "stack": true
        }
  )
  .addSeriesOverride(
        {
          "alias": "Swap",
          "fill": 5,
          "stack": true
        }
  )
  .addTarget(
      prometheus.target(
        'max(node_memory_MemTotal_bytes{node_name=~"$host"}) without(job) -
        (max(node_memory_MemFree_bytes{node_name=~"$host"}) without(job) +
        max(node_memory_Buffers_bytes{node_name=~"$host"}) without(job) +
        (max(node_memory_Cached_bytes{node_name=~"$host",job=~"rds-enhanced|linux"}) without (job) or
        max(node_memory_Cached_bytes{node_name=~"$host",job="rds-basic"}) without (job)))',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Used',
      )
  )
  .addTarget(
      prometheus.target(
        'node_memory_MemFree_bytes{node_name=~"$host"}',
        interval='$interval',
        legendFormat='Free',
        intervalFactor=1,
      )
  )
  .addTarget(
      prometheus.target(
        'node_memory_Buffers_bytes{node_name=~"$host"}',
        interval='$interval',
        legendFormat='Buffers',
        intervalFactor=1,
      )
  )
  .addTarget(
      prometheus.target(
        'max(node_memory_Cached_bytes{node_name=~"$host",job=~"rds-enhanced|linux"}) without (job) or
        max(node_memory_Cached_bytes{node_name=~"$host",job=~"rds-basic"}) without (job)',
        interval='$interval',
        legendFormat='Cached',
        intervalFactor=1,
      )
  ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 62,
  },
  style=null,
)//17 graph
.addPanel(
    row.new(
      title='',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 69,
    },
    style=null,
)//327 row
.addPanel(
  graphPanel.new(
    '$host - Swap Usage',//title
    fill=6,
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
    editable=true,
    repeat='host',
    maxPerRow=6,
    stack=true,
    decimalsY1=2,
    format='bytes',
    min=0,
    aliasColors={
        "Used": "#bf1b00"
      },
    links=[
            {
            "dashUri": "db/system-overview",
            "dashboard": "System Overview",
            "includeVars": true,
            "keepTime": true,
            "targetBlank": true,
            "title": "System Overview",
            "type": "dashboard",
            }
     ],
  )
  .addSeriesOverride(
    {
      "alias": "Used",
      "color": "#bf1b00"
    }
  )
  .addSeriesOverride(
      {
        "alias": "Free",
        "color": "#AEA2E0"
      }
  )
  .addSeriesOverride(
    {
      "alias": "Total",
      "color": "#511749",
      "fill": 0,
      "stack": false
    }
  )
  .addTarget(
      prometheus.target(
        'node_memory_SwapTotal_bytes{node_name=~"$host"} - node_memory_SwapFree_bytes{node_name=~"$host"}',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Used',
        calculatedInterval='2s',
        step=300,
      )
  )
  .addTarget(
      prometheus.target(
        'node_memory_SwapFree_bytes{node_name=~"$host"}',
        interval='$interval',
        legendFormat='Free',
        intervalFactor=1,
        calculatedInterval='2s',
        step=300,
      )
  )
  .addTarget(
      prometheus.target(
        'node_memory_SwapTotal_bytes{node_name=~"$host"}',
        interval='$interval',
        legendFormat='Total',
        intervalFactor=1,
      )),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 70,
  },
  style=null,
)//95 graph
.addPanel(
    row.new(
      title='',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 77,
    },
    style=null,
)//325 row
.addPanel(
  graphPanel.new(
    '$host - Swap Activity',//title
    fill=1,
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
    editable=true,
    repeat='host',
    maxPerRow=6,
    decimalsY1=2,
    formatY1='Bps',
    links=[
            {
            "dashUri": "db/system-overview",
            "dashboard": "System Overview",
            "includeVars": true,
            "keepTime": true,
            "targetBlank": true,
            "title": "System Overview",
            "type": "dashboard",
            }
     ],
  )
  .addTarget(
      prometheus.target(
        'rate(node_vmstat_pswpin{node_name=~"$host"}[$interval]) * 4096 or irate(node_vmstat_pswpin{node_name=~"$host"}[5m]) * 4096',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Swap In (Reads)',
      )
  )
  .addTarget(
      prometheus.target(
        'rate(node_vmstat_pswpout{node_name=~"$host"}[$interval]) * 4096 or irate(node_vmstat_pswpout{node_name=~"$host"}[5m]) * 4096',
        interval='$interval',
        legendFormat='Swap Out (Writes)',
        intervalFactor=1,
      )
    ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 78,
  },
  style=null,
)//108 graph
.addPanel(
    row.new(
      title='Disk partitions',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 85,
    },
    style=null,
)//323 row
.addPanel(
  text.new(
    content='<h1><i><font color=#5991A7><b><center>Disk partitions</center></b></font></i></h1>',
    height='20px',
    mode='html',
    transparent=true,
  ),
  gridPos={
        "h": 2,
        "w": 24,
        "x": 0,
        "y": 86,
      },
  style=null,
)//102 text
.addPanel(
    row.new(
      title='',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 88,
    },
    style=null,
)//321 row
.addPanel(
  graphPanel.new(
    '$host - Mountpoint Usage',//title
    fill=0,
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
    editable=true,
    repeat='host',
    maxPerRow=6,
    stack=true,
    value_type='cumulative',
    maxY1='1',
    minY1=0,
    formatY1='percentunit',
    links=[
      {
        "dashUri": "db/disk-space",
        "dashboard": "Disk Space",
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
        '1 - node_filesystem_free_bytes{node_name=~"$host", fstype!~"rootfs|selinuxfs|autofs|rpc_pipefs|tmpfs"} / node_filesystem_size_bytes{node_name=~"$host", fstype!~"rootfs|selinuxfs|autofs|rpc_pipefs|tmpfs"}',
        interval='$interval',
        intervalFactor=1,
        legendFormat='{{mountpoint}}',
        step=1200,
      )
    ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 89,
  },
  style=null,
)//9 graph
.addPanel(
    row.new(
      title='',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 96,
    },
    style=null,
)//319 row
.addPanel(
  graphPanel.new(
    '$host - Free Space',//title
    fill=0,
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
    editable=true,
    repeat='host',
    maxPerRow=6,
    stack=true,
    value_type='cumulative',
    decimalsY1=2,
    minY1=0,
    formatY1='bytes',
    links=[
      {
        "dashUri": "db/disk-space",
        "dashboard": "Disk Space",
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
        'node_filesystem_free_bytes{node_name=~"$host", fstype!~"rootfs|selinuxfs|autofs|rpc_pipefs|tmpfs"} ',
        interval='$interval',
        intervalFactor=1,
        legendFormat='{{mountpoint}}',
        step=1200,
      )
    ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 97,
  },
  style=null,
)//156 graph
.addPanel(
    row.new(
      title='Disk performance',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 104,
    },
    style=null,
)//302 row
.addPanel(
  text.new(
    content='<h1><i><font color=#5991A7><b><center>Disk performance</center></b></font></i></h1>',
    height='20px',
    mode='html',
    transparent=true,
  ),
  gridPos={
        "h": 2,
        "w": 24,
        "x": 0,
        "y": 105,
      },
  style=null,
)//104 text
.addPanel(
    row.new(
      title='',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 107,
    },
    style=null,
)//300 row
.addPanel(
  graphPanel.new(
    '$host - I/O Activity',//title
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
    repeat='host',
    maxPerRow=6,
    min=0,
    formatY1='Bps',
    formatY2='bytes',
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
  )
  .addTarget(
      prometheus.target(
        'rate(node_vmstat_pgpgin{node_name=~"$host"}[$interval]) * 1024 or irate(node_vmstat_pgpgin{node_name=~"$host"}[5m]) * 1024',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Page In',
        calculatedInterval='2s',
        step=300,
      )
    )
  .addTarget(
        prometheus.target(
          'rate(node_vmstat_pgpgout{node_name=~"$host"}[$interval]) * 1024 or irate(node_vmstat_pgpgout{node_name=~"$host"}[5m]) * 1024',
          interval='$interval',
          intervalFactor=1,
          legendFormat='Page Out',
          calculatedInterval='2s',
          step=300,
        )
      ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 108,
  },
  style=null,
)//153 graph
.addPanel(
    row.new(
      title='',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 115,
    },
    style=null,
)//298 row
.addPanel(
  graphPanel.new(
    '$host - Disk Operations',//title
    description='Shows amount of physical IOs (reads and writes) different devices are serving. Spikes in number of IOs served often corresponds to performance problems due to IO subsystem overload.',
    fill=1,
    linewidth=2,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    legend_alignAsTable=true,
    legend_show=true,
    editable=true,
    nullPointMode='connected',
    repeat='host',
    maxPerRow=6,
    value_type='cumulative',
    formatY1='iops',
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
  )
  .addTarget(
      prometheus.target(
        "rate(node_disk_reads_completed_total{node_name=~'$host'}[$interval]) or irate(node_disk_reads_completed_total{node_name=~'$host'}[5m])",
        interval='$interval',
        intervalFactor=1,
        legendFormat='Reads: {{device}}',
        step=2400,
      )
    )
  .addTarget(
        prometheus.target(
          "rate(node_disk_writes_completed_total{node_name=~'$host'}[$interval]) or irate(node_disk_writes_completed_total{node_name=~'$host'}[5m])",
          interval='$interval',
          intervalFactor=1,
          legendFormat='Writes: {{device}}',
          step=1200,
        )
      ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 116,
  },
  style=null,
)//14 graph
.addPanel(
    row.new(
      title='',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 123,
    },
    style=null,
)//296 row
.addPanel(
  graphPanel.new(
    '$host - Disk Bandwidth',//title
    description='Shows volume of reads and writes the storage is handling. This can be better measure of IO capacity usage for network attached and SSD storage as it is often bandwidth limited.  Amount of data being written to the disk can be used to estimate Flash storage life time.',
    fill=2,
    linewidth=2,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    legend_alignAsTable=true,
    legend_show=true,
    editable=true,
    nullPointMode='connected',
    repeat='host',
    maxPerRow=6,
    value_type='cumulative',
    formatY1='Bps',
    links=[
        {
          "dashUri": "db/disk-performance",
          "dashboard": "Disk Performance",
          "includeVars": true,
          "keepTime": true,
          "targetBlank": false,
          "title": "Disk Performance",
          "type": "dashboard"
        }
     ],
  )
  .addTarget(
      prometheus.target(
        'rate(node_disk_read_bytes_total{node_name=~"$host"}[$interval]) or irate(node_disk_read_bytes_total{node_name=~"$host"}[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Reads: {{device}}',
        step=2400,
      )
    )
  .addTarget(
        prometheus.target(
          'rate(node_disk_written_bytes_total{node_name=~"$host"}[$interval]) or irate(node_disk_written_bytes_total{node_name=~"$host"}[5m])',
          interval='$interval',
          intervalFactor=1,
          legendFormat='Writes: {{device}}',
          step=2400,
        )
      ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 124,
  },
  style=null,
)//18 graph
.addPanel(
    row.new(
      title='',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 131,
    },
    style=null,
)//402 row
.addPanel(
  graphPanel.new(
    '$host - Disk IO Utilization',//title
    description='Shows disk Utilization as percent of the time when there was at least one IO request in flight. It is designed to match utilization available in iostat tool. It is not very good measure of true IO Capacity Utilization. Consider looking at IO latency and Disk Load Graphs instead.',
    fill=1,
    decimals=2,
    linewidth=2,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    legend_alignAsTable=true,
    legend_avg=true,
    legend_max=true,
    legend_min=true,
    legend_show=true,
    legend_values=true,
    editable=true,
    nullPointMode='connected',
    repeat='host',
    maxPerRow=6,
    value_type='cumulative',
    formatY1='percentunit',
    maxY1='1.1',
    minY1='0',
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
  )
  .addTarget(
      prometheus.target(
        'rate(node_disk_io_time_seconds_total{node_name=~"$host"}[$interval]) or irate(node_disk_io_time_seconds_total{node_name=~"$host"}[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='{{device}}',
      )
      ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 132,
  },
  style=null,
)//19 graph
.addPanel(
    row.new(
      title='',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 139,
    },
    style=null,
)//400 row
.addPanel(
  graphPanel.new(
    '$host - Disk Latency',//title
    description='Shows average latency for Reads and Writes IO Devices.  Higher than typical latency for highly loaded storage indicates saturation (overload) and is frequent cause of performance problems.  Higher than normal latency also can indicate internal storage problems.',
    fill=2,
    decimals=2,
    linewidth=2,
    lines=false,
    points=true,
    datasource='Prometheus',
    pointradius=1,
    paceLength=10,
    legend_alignAsTable=true,
    legend_avg=true,
    legend_hideEmpty=true,
    legend_hideZero=true,
    legend_max=true,
    legend_min=true,
    legend_show=true,
    legend_values=true,
    editable=true,
    repeat='host',
    maxPerRow=6,
    format='s',
    logBase1Y=2,
    minY2=0,
  )
  .addTarget(
      prometheus.target(
        '(rate(node_disk_read_time_seconds_total{node_name=~"$host"}[$interval]) /
        rate(node_disk_reads_completed_total{node_name=~"$host"}[$interval])) or
        (irate(node_disk_read_time_seconds_total{node_name=~"$host"}[5m]) /
        irate(node_disk_reads_completed_total{node_name=~"$host"}[5m]))
        or avg_over_time(aws_rds_read_latency_average{node_name=~"$host"}[$interval])/1000 or
        avg_over_time(aws_rds_read_latency_average{node_name=~"$host"}[5m])/1000',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Read: {{ device }}',
        calculatedInterval='2m',
        step=300,
      )
      )
  .addTarget(
          prometheus.target(
            '(rate(node_disk_write_time_seconds_total{node_name=~"$host"}[$interval]) /
            rate(node_disk_writes_completed_total{node_name=~"$host"}[$interval])) or
            (irate(node_disk_write_time_seconds_total{node_name=~"$host"}[5m]) /
            irate(node_disk_writes_completed_total{node_name=~"$host"}[5m]))
            or (avg_over_time(aws_rds_write_latency_average{node_name=~"$host"}[$interval])/1000 or
            avg_over_time(aws_rds_write_latency_average{node_name=~"$host"}[5m])/1000)',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Write: {{ device }}',
            calculatedInterval='2m',
            step=300,
          )
          ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 140,
    },
  style=null,
)//159 graph
.addPanel(
    row.new(
      title='',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 147,
    },
    style=null,
)//398 row
.addPanel(
  graphPanel.new(
    '$host - Disk Load',//title
    description='Shows how much disk was loaded for reads or writes as average number of outstanding requests at different period of time.  High disk load is a good measure of actual storage utilization. Different storage types handle load differently - some will show latency increases on low loads others can handle higher load with no problems.',
    fill=2,
    decimals=2,
    linewidth=2,
    lines=false,
    points=true,
    datasource='Prometheus',
    pointradius=1,
    paceLength=10,
    legend_alignAsTable=true,
    legend_avg=true,
    legend_hideEmpty=false,
    legend_hideZero=true,
    legend_max=true,
    legend_min=true,
    legend_show=true,
    legend_values=true,
    editable=true,
    repeat='host',
    maxPerRow=6,
    min=0,
  )
  .addTarget(
      prometheus.target(
        'rate(node_disk_read_time_seconds_total{node_name=~"$host"}[$interval]) or
        irate(node_disk_read_time_seconds_total{node_name=~"$host"}[5m])',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Read: {{ device }}',
        calculatedInterval='2m',
        step=300,
      )
      )
  .addTarget(
          prometheus.target(
            'rate(node_disk_write_time_seconds_total{node_name=~"$host"}[$interval]) or
            irate(node_disk_write_time_seconds_total{node_name=~"$host"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Write: {{ device }}',
            calculatedInterval='2m',
            step=300,
          )
          ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 148,
    },
  style=null,
)//162 graph
.addPanel(
    row.new(
      title='Network',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 155,
    },
    style=null,
)//396 row
.addPanel(
  text.new(
    content='<h1><i><font color=#5991A7><b><center>Network</center></b></font></i></h1>',
    height='20px',
    mode='html',
    transparent=true,
  ),
  gridPos={
        "h": 2,
        "w": 24,
        "x": 0,
        "y": 156,
      },
  style=null,
)//103 text
.addPanel(
    row.new(
      title='',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 158,
    },
    style=null,
)//394 row
.addPanel(
  graphPanel.new(
    'Network Traffic',//title
    fill=2,
    decimals=2,
    linewidth=2,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    legend_alignAsTable=true,
    legend_avg=true,
    legend_max=true,
    legend_min=true,
    legend_show=true,
    legend_values=true,
    nullPointMode='connected',
    editable=true,
    repeat='host',
    maxPerRow=6,
    value_type='cumulative',
    formatY1='Bps',
    labelY1='bits out (-) / bits in (+)',
    links=[
        {
          "dashUri": "db/system-overview",
          "dashboard": "System Overview",
          "includeVars": true,
          "keepTime": true,
          "targetBlank": true,
          "title": "System Overview",
          "type": "dashboard"
        }
      ],
  )
  .addSeriesOverride(
      {
          "alias": "Outbound",
          "transform": "negative-Y"
        }
        )
  .addTarget(
      prometheus.target(
        'sum(rate(node_network_receive_bytes_total{node_name=~"$host", device!="lo"}[$interval])) or
        sum(irate(node_network_receive_bytes_total{node_name=~"$host", device!="lo"}[5m])) or
        sum(max_over_time(rdsosmetrics_network_rx{node_name=~"$host"}[$interval])) or
        sum(max_over_time(rdsosmetrics_network_rx{node_name=~"$host"}[5m])) ',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Inbound',
      )
      )
  .addTarget(
          prometheus.target(
            'sum(rate(node_network_transmit_bytes_total{node_name=~"$host", device!="lo"}[$interval])) or
            sum(irate(node_network_transmit_bytes_total{node_name=~"$host", device!="lo"}[5m])) or
            sum(max_over_time(rdsosmetrics_network_tx{node_name=~"$host"}[$interval])) or
            sum(max_over_time(rdsosmetrics_network_tx{node_name=~"$host"}[5m]))',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Outbound',
          )
          ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 159,
    },
  style=null,
)//12 graph
.addPanel(
    row.new(
      title='',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 166,
    },
    style=null,
)//392 row
.addPanel(
  graphPanel.new(
    'Network Utilization Hourly',//title
    fill=1,
    decimals=2,
    linewidth=1,
    bars=true,
    lines=false,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    legend_alignAsTable=true,
    legend_avg=true,
    legend_max=true,
    legend_min=true,
    legend_show=true,
    legend_values=true,
    timeFrom='24h',
    stack=true,
    editable=true,
    repeat='host',
    maxPerRow=6,
    formatY1='bytes',
    minY1='0',
    links=[
        {
          "dashUri": "db/system-overview",
          "dashboard": "System Overview",
          "includeVars": true,
          "keepTime": true,
          "targetBlank": true,
          "title": "System Overview",
          "type": "dashboard"
        }
      ],
  )
  .addTarget(
      prometheus.target(
        'sum(increase(node_network_receive_bytes_total{node_name=~"$host", device!="lo"}[1h]))',
        interval='1h',
        intervalFactor=1,
        legendFormat='Received',
      )
      )
  .addTarget(
          prometheus.target(
            'sum(increase(node_network_transmit_bytes_total{node_name=~"$host", device!="lo"}[1h]))',
            interval='1h',
            intervalFactor=1,
            legendFormat='Sent',
          )
          ),
  gridPos={
    "h": 7,
    "w": 12,
    "x": 0,
    "y": 167,
    },
  style=null,
)//105 graph
