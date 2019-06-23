local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local annotation = grafana.annotation;
local template = grafana.template;
local timepicker = grafana.timepicker;
local prometheus = grafana.prometheus;
local row = grafana.row;
local pmm = grafana.pmm;


dashboard.new(
  '_PMM Query Analytics',
  time_from='now-12h',
  editable=false,
  refresh= false,
  graphTooltip='shared_crosshair',
  schemaVersion=16,
  version=2,
  tags=['QAN','Percona'],
  iteration=1539869043503,
  uid='7w6Q3PJmz',
)
.addAnnotation(
  grafana.annotation.datasource(
    'PMM Annotations',
    '-- Grafana --',
    enable=true,
    hide=true,
    type='tags',
    builtIn=1,
    iconColor='#e0752d',
    limit=100,
    tags = ["pmm_annotation",
            "$host",
            "$service"
            ],
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
  template.new(
  'host',
  'Prometheus',
  'label_values(mysql_up, node_name)',
  label='Host',
  refresh='load',
  sort=1,
  includeAll=false,
  ),
)
.addTemplate(
    template.interval('interval', 'auto,1s,5s,1m,5m,1h,6h,1d', 'auto', label='Interval', auto_count=200, auto_min='1s'),
)
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
)//7 row
.addPanel(
  pmm.new(
    'PMM Query Analytics',
    'pmm-qan-app-panel',
    datasource='Prometheus',
  )
  .addTarget(
      prometheus.target(
        '',
        refId='A',
        intervalFactor=2,
      )
  ),
  gridPos={
   "h": 11,
   "w": 24,
   "x": 0,
   "y": 10,
  },
  style=null,
)//1 pmm
