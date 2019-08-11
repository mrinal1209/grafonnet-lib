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
local tablePanel = grafana.tablePanel;
local pmm=grafana.pmm;


dashboard.new(
  'MySQL Command/Handler Counters Compare',
  time_from='now-12h',
  editable=false,
  refresh= "1m",
  graphTooltip='shared_crosshair',
  schemaVersion=18,
  version=3,
  tags=['Percona','MySQL'],
  iteration=1552402341763,
  uid="000000170",
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
    tags = [  "pmm_annotation",
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
  'label_values(mysql_up, node_name)',
  label='Host',
  refresh='load',
  sort=1,
  multi=true,
  skipUrlSync=false,
  definition='label_values(mysql_up, node_name)',
  includeAll=false,
  tagsQuery='',
  tagValuesQuery='',
  ),
)
.addTemplate(
  template.new(
  'service',
  'Prometheus',
  'label_values(mysql_up{node_name=~"$host"}, service_name)',
  label='Service',
  refresh='load',
  sort=0,
  multi=true,
  skipUrlSync=false,
  definition='label_values(mysql_up{node_name=~"$host"}, service_name)',
  includeAll=false,
  tagsQuery='',
  tagValuesQuery='',
  ),
)
.addTemplate(
  template.new(
  'command',
  'Prometheus',
  'label_values(mysql_global_status_commands_total{service_name=~"$service"},command)',
  label='Command',
  refresh='time',
  sort=1,
  multi=true,
  skipUrlSync=false,
  definition='label_values(mysql_global_status_commands_total{service_name=~"$service"},command)',
  includeAll=true,
  tagsQuery='',
  tagValuesQuery='',
  ),
)
.addTemplate(
  template.new(
  'handler',
  'Prometheus',
  'label_values(mysql_global_status_handlers_total{service_name=~"$service"},handler)',
  label='Handler',
  refresh='load',
  sort=1,
  multi=true,
  skipUrlSync=false,
  definition='label_values(mysql_global_status_handlers_total{service_name=~"$service"},handler)',
  includeAll=true,
  tagsQuery='',
  tagValuesQuery='',
  ),
)
.addPanel(
  pmm.new(
    ' ',
    'digiapulssi-breadcrumb-panel',
    isRootDashboard=false,
    transparent=true,
  )
  .addTarget(
  prometheus.target(
    '',
    intervalFactor=1,
    )
  ),
  gridPos={
        "h": 3,
        "w": 24,
        "x": 0,
        "y": 0
      },
  style=null
)//999 pmm
.addPanel(
    row.new(
      title='',
    )
    ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 0,
    },
    style=null,
)//255 row
.addPanel(
  text.new(
    content='',
    height='50px',
    maxPerRow=6,
    mode='html',
    title='$service',
    transparent=true,
  ),
  gridPos={
    "h": 1,
    "w": 12,
    "x": 0,
    "y": 1
      },
  style=null,
)//12 text
.addPanel(
    row.new(
      title='',
    )
    ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 2,
    },
    style=null,
)//256 row
.addPanel(
  text.new(
    content='<h1><i><font color=#cfcfcf><b><center>Commands</center></b></font></i></h1>',
    height='25',
    mode='html',
    title='',
    transparent=true,
  ),
  gridPos={
      "h": 2,
      "w": 24,
      "x": 0,
      "y": 3
      },
  style=null,
)//15 text
.addPanel(
    row.new(
      title='$service- $command',
    )
    ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 5,
    },
    style=null,
)//258 row
.addPanel(
      graphPanel.new(
        '$service - $command',//title
        fill=2,
        linewidth=2,
        decimals=null,
        datasource='Prometheus',
        pointradius=1,
        paceLength=10,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        editable=true,
        maxPerRow=6,
        repeat='service',
        repeatDirection='h',
        minY1='0',
        aliasColors={
          "insert": "#447ebc",
          "select": "#447ebc"
        },
        )
      .addSeriesOverride({
          "alias": "/.*/",
          "color": "#614d93"
        })
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_commands_total{command="$command", service_name="$service"}[$interval]) or irate(mysql_global_status_commands_total{command="$command", service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='{{command}}',
          )
      ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 0,
        "y": 6
      },style=null
)//1 graph
.addPanel(
    row.new(
      title='',
    )
    ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 13,
    },
    style=null,
)//259 row
.addPanel(
  text.new(
    content='<h1><i><font color=#cfcfcf><b><center>Handlers</center></b></font></i></h1>',
    height='25',
    mode='html',
    title='',
    transparent=true,
  ),
  gridPos={
      "h": 2,
      "w": 24,
      "x": 0,
      "y": 14
      },
  style=null,
)//16 text
.addPanel(
    row.new(
      title='$service - $handler',
    )
    ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 16,
    },
    style=null,
)//259 row
.addPanel(
      graphPanel.new(
        '$service - $handler',//title
        fill=2,
        linewidth=2,
        decimals=0,
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
        maxPerRow=6,
        repeat='service',
        repeatDirection='h',
        minY1='0',
        decimalsY1=0,
        aliasColors={
          "commit": "#614d93"
        },
        )
      .addSeriesOverride({
          "alias": "/.*/",
          "color": "#806eb7"
        })
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_handlers_total{handler="$handler",service_name="$service"}[$interval]) or \nirate(mysql_global_status_handlers_total{handler="$handler",service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='{{handler}}',
          )
      ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 0,
        "y": 17
      },style=null
)//9 graph
