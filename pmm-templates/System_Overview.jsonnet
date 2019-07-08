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
  'System Overview',
  time_from='now-12h',
  editable=true,
  refresh= "1m",
  graphTooltip='shared_crosshair',
  schemaVersion=18,
  version=4,
  tags=['OS','Percona'],
  iteration=1553887307310,
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
)//98 text
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
)//52 singlestat
