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
  editable=true,
  refresh= "1m",
  graphTooltip='shared_crosshair',
  schemaVersion=18,
  version=18,
  tags=['OS','Percona'],
  iteration=1553870190718,
  uid="000000205",
  gnetId=405,
  description='Dashboard to view multiple servers',
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
  tablePanel.new(
    title='$host - System Info',
    datasource='Prometheus',
    fontSize='100%',
    maxPerRow=6,
    repeatDirection='h',
    repeatIteration=1553870190718,
    scroll=true,
    showHeader=true,
    sort={
      "col":0,
      "desc":true,
    },
    repeat=null,
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
      "x": 12,
      "y": 3,
    },
    style=null,
)//429 table
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
  singlestat.new(
    '$host - System Uptime',//title
    format='s',
    datasource='Prometheus',
    valueName='current',
    colorValue=true,
    thresholds='300,3600',
    repeatIteration=1553870190718,
    repeatDirection='h',
    maxPerRow=6,
    decimals=1,
    height='100px',
    repeat=null,
    colors=[
      '#d44a3a',
      'rgba(237, 129, 40, 0.89)',
      '#299c46',
    ],
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
  "x": 12,
  "y": 7,
  },
  style=null,
)//430 singlestat
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
  singlestat.new(
    '$host - CPU Cores',//title
    format='none',
    datasource='Prometheus',
    valueName='avg',
    thresholds='',
    repeatIteration=1553870190718,
    editable=true,
    repeat=null,
    maxPerRow=6,
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
      "type": "dashboard"
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
        "x": 12,
        "y": 10,
  },
  style=null,
)//431 singlestat
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
  singlestat.new(
    'title": "$host - RAM',//title
    format='bytes',
    datasource='Prometheus',
    valueName='current',
    thresholds='',
    decimals=2,
    maxPerRow=6,
    height='100px',
    prefixFontSize='80%',
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
    repeatIteration=1553870190718,
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
        "x": 12,
        "y": 13,
  },
  style=null,
)//432 singlestat
//here
