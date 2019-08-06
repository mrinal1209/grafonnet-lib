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
local pmm = grafana.pmm;
local pmmPanel = grafana.pmmSinglestat;


dashboard.new(
  'Home Dashboard',
  time_from='now-12h',
  editable=false,
  refresh= "1m",
  graphTooltip='shared_crosshair',
  schemaVersion=18,
  version=1,
  tags=['Percona','Insight'],
  iteration=1564754344657,
  uid="Fxvd1timk",
  timepicker = timepicker.new(
    hidden=false,
    collapse=false,
    enable=true,
    notice=false,
    now=true,
    status='Stable',
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
    iconColor='rgba(0, 211, 255, 1)',
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
  multi=true,
  multiFormat='regex values',
  allFormat='glob',
  skipUrlSync=false,
  definition='label_values(node_boot_time_seconds, node_name)',
  includeAll=true,
  tagsQuery='up',
  tagValuesQuery='instance',
  ),
)
.addTemplate(
  template.new(
  'service',
  'Prometheus',
  'label_values({__name__=~"postgres_exporter_build_info|mysqld_exporter_build_info|mongodb_exporter_build_info|proxysql_exporter_build_info",node_name=~"$host"}, service_name)',
  label='Service',
  refresh='load',
  sort=1,
  multi=true,
  multiFormat='regex values',
  allFormat='glob',
  skipUrlSync=false,
  definition='label_values({__name__=~"postgres_exporter_build_info|mysqld_exporter_build_info|mongodb_exporter_build_info|proxysql_exporter_build_info",node_name=~"$host"}, service_name)',
  includeAll=true,
  tagsQuery='up',
  tagValuesQuery='instance',
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
)//1340 row
.addPanel(
  text.new(
    content='<br>\n<div class=\"text-center dashboard-header\">\n<img src=\"/graph/public/plugins/pmm-app/img/pmm-logo.svg\" height=\"60px\" width=\"60px\">\n  <span>Percona Monitoring and Management</span>\n</div>',
    datasource='Prometheus',
    editable=true,
    height='10px',
    mode='html',
    transparent=true,
  ),
  gridPos={
    "h": 3,
    "w": 24,
    "x": 0,
    "y": 1
      },
  style=null,
)//1339 text
.addPanel(
    row.new(
      title='General information',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 4,
    },
    style=null,
)//1341 row
.addPanel(
  text.new(
    content='**Overview**  \n[Percona Monitoring and Management (PMM)](https://www.percona.com/pmm) is a free and open-source platform for managing and monitoring MySQL and MongoDB performance, and provides time-based analysis to ensure that your data works as efficiently as possible. \n\n**Documentation**  \nPlease consult the official [PMM documentation](https://www.percona.com/doc/percona-monitoring-and-management/index.html) to learn more about PMM. Also of interest are the [Release notes](https://www.percona.com/doc/percona-monitoring-and-management/release-notes/index.html) and [FAQ](https://www.percona.com/doc/percona-monitoring-and-management/faq.html) for common questions about PMM.\n\n**Community and Blogs**  \nOn the [PMM Community Forums](https://www.percona.com/forums/questions-discussions/percona-monitoring-and-management) you will find help from Perconians and the Community at large.  Further, we publish PMM announcements and use cases regularly on the [Percona Database Performance Blog](https://www.percona.com/blog/category/percona-monitoring-and-management/)  \n\n**Get Help from Percona**  \nAre you looking for assistance that comes with a response-time guarantee? Let our [Support team](https://www.percona.com/services/support?utm_source=pmm&utm_medium=web&utm_campaign=support_link)  help you!\nAlready a customer? Log in to your [Percona Support Portal](https://customers.percona.com) \n\n\n\n',
    height='330px',
    mode='markdown',
  ),
  gridPos={
      "h": 11,
       "w": 12,
       "x": 0,
       "y": 5
      },
  style=null,
)//1021 text
.addPanel(
  pmm.dashlist(
    folderId = 0,
    headings = false,
    height = "330px",
    limit = 3,
    recent=true,
    search=false,
    starred=true,
    title = 'Starred and Recently used Dashboards',
  ),
  gridPos={
      "h": 11,
      "w": 6,
      "x": 12,
      "y": 5,
  },
  style=null,
)//1020 pmm-dashlist
.addPanel(
  singlestat.new(
    'Systems under monitoring',//title
    format='none',
    editable=true,
    decimals=0,
    datasource='Prometheus',
    valueName='current',
    thresholds='',
    colors=[
      "rgba(245, 54, 54, 0.9)",
       "#1F60C4",
       "rgba(50, 172, 45, 0.97)",
    ],
    interval='$interval',
    height='50',
    sparklineShow=true,
    prefixFontSize='100%',
    postfixFontSize='100%',
    valueFontSize='100%',
  )
  .addTarget(
    prometheus.target(
      'count(node_memory_MemTotal_bytes{})',
      intervalFactor = 1,
      interval='5m',
      step=300,
      instant=true,
    )
  ),
  gridPos = {
    "h": 3,
    "w": 6,
    "x": 18,
    "y": 5,
  },
  style=null,
)//1335 singlestat
.addPanel(
  singlestat.new(
    'Monitored DB Instances',//title
    format='none',
    editable=true,
    decimals=0,
    datasource='Prometheus',
    valueName='current',
    thresholds='',
    colors=[
      "rgba(245, 54, 54, 0.9)",
       "#1F60C4",
       "rgba(50, 172, 45, 0.97)",
    ],
    interval='$interval',
    height='50',
    sparklineShow=true,
    prefixFontSize='100%',
    postfixFontSize='100%',
    valueFontSize='100%',
    valueMaps=[],
  )
  .addTarget(
    prometheus.target(
      'count(mysql_global_status_uptime{service_name=~"$service",node_name=~"$host"} or
      mongodb_up {service_name=~"$service",node_name=~"$host"} or
      pg_up{service_name=~"$service",node_name=~"$host"} or
      postgresql_up{service_name=~"$service",node_name=~"$host"})',
      intervalFactor = 1,
      interval='5m',
      instant=true,
      calculatedInterval='10m',
      step=300,
    )
  ),
  gridPos = {
    "h": 3,
    "w": 6,
    "x": 18,
    "y": 8,
  },
  style=null,
)//1336 singlestat
.addPanel(
  pmm.new(
    '',
    'pmm-update-panel',
    height='120px',
    datasource='Prometheus',
  )
  .addTarget(
    prometheus.target(
      '',
    )
  ),
  gridPos={
      "h": 5,
        "w": 6,
        "x": 18,
        "y": 11
  },
  style=null,
)//1337 pmm-update-panel
.addPanel(
    row.new(
      title='Environment Overview',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 16
    },
    style=null,
)//1342 row
.addPanel(
  text.new(
    content='<b>All</b>',
    mode='html',
    title='Host',
    links=[
        {
          "dashUri": "db/system-overview",
          "dashboard": "System Overview",
          "includeVars": false,
          "keepTime": true,
          "targetBlank": true,
          "title": "System Overview",
          "type": "dashboard"
        }
      ],
  ),
  gridPos={
    "h": 3,
     "w": 2,
     "x": 0,
     "y": 17
      },
  style=null,
)//1298 text
.addPanel(
  pmmPanel.new(
    'CPU Busy',//title
    format='percent',
    decimals=0,
    datasource='Prometheus',
    valueName='current',
    thresholds='70,90',
    colorValue=true,
    colors=[
      "rgba(50, 172, 45, 0.97)",
     "rgba(237, 129, 40, 0.89)",
     "rgba(245, 54, 54, 0.9)",
    ],
    interval='$interval',
    height='50',
    sparklineShow=true,
    prefixFontSize='80%',
    postfixFontSize='80%',
    links=[
        {
          "dashUri": "db/system-overview",
          "dashboard": "System Overview",
          "includeVars": false,
          "keepTime": true,
          "targetBlank": true,
          "title": "System Overview",
          "type": "dashboard"
        }
      ],
  )
  .addTarget(
    prometheus.target(
      'avg by () ((sum by (node_name,cpu) ( (clamp_max(rate(node_cpu_seconds_total{node_name=~"$host",mode!="idle",mode!="iowait"}[$interval]),1)) or
      (clamp_max(irate(node_cpu_seconds_total{node_name=~"$host",mode!="idle",mode!="iowait"}[5m]),1)) ))*100 or
      sum by () (avg_over_time(node_cpu_average{node_name=~"$host",mode!="idle", mode!="total",mode!="idle"}[$interval]) or
      avg_over_time(node_cpu_average{node_name=~"$host",mode!="idle",mode!="total",mode!="idle"}[5m])))',
      intervalFactor = 1,
      interval='$interval',
      calculatedInterval='10m',
      metric='node_mem',
      step=300,
    )
  ),
  gridPos = {
        "h": 3,
        "w": 2,
        "x": 2,
        "y": 17,
  },
  style=null,
)//1299 pmm-singlestat
.addPanel(
  pmmPanel.new(
    'Mem Avail',//title
    format='percent',
    decimals=0,
    datasource='Prometheus',
    valueName='current',
    thresholds='10,20',
    colorValue=true,
    colors=[
      "rgba(245, 54, 54, 0.9)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(50, 172, 45, 0.97)",
    ],
    interval='$interval',
    height='50',
    sparklineShow=true,
    prefixFontSize='80%',
  )
  .addTarget(
    prometheus.target(
      'avg by () ((node_memory_MemAvailable_bytes{node_name=~"$host"} or
      (node_memory_MemFree_bytes{node_name=~"$host"} + node_memory_Buffers_bytes{node_name=~"$host"} +
      node_memory_Cached_bytes{node_name=~"$host"})) / node_memory_MemTotal_bytes{node_name=~"$host"}) * 100',
      intervalFactor = 1,
      interval='$interval',
      calculatedInterval='10m',
      metric='node_mem',
      step=300,
    )
  ),
  gridPos = {
        "h": 3,
        "w": 2,
        "x": 4,
        "y": 17,
  },
  style=null,
)//1300 pmm-singlestat
.addPanel(
  singlestat.new(
    'Disk Reads',//title
    format='Bps',
    decimals=1,
    datasource='Prometheus',
    valueName='current',
    thresholds='10000000,100000000',
    colorValue=false,
    colors=[
      "#0a437c",
      "#1f78c1",
      "#5195ce",
    ],
    interval='$interval',
    height='50',
    sparklineShow=true,
    prefixFontSize='30%',
    postfixFontSize='30%',
    valueFontSize='30%',
    links=[
        {
          "dashUri": "db/disk-performance",
          "dashboard": "Disk Performance",
          "includeVars": false,
          "keepTime": true,
          "targetBlank": true,
          "title": "Disk Performance",
          "type": "dashboard"
        }
      ],
  )
  .addTarget(
    prometheus.target(
      'sum by () (rate(node_vmstat_pgpgin{node_name=~"$host"}[$interval]) or irate(node_vmstat_pgpgin{node_name=~"$host"}[5m])) * 1024',
      intervalFactor = 1,
      interval='$interval',
      calculatedInterval='10m',
      metric='node_mem',
      step=300,
    )
  ),
  gridPos = {
        "h": 3,
        "w": 2,
        "x": 6,
        "y": 17,
  },
  style=null,
)//1301 singlestat
.addPanel(
  singlestat.new(
    'Disk Writes',//title
    format='Bps',
    decimals=1,
    datasource='Prometheus',
    valueName='current',
    thresholds='10000000,100000000',
    colorValue=false,
    colors=[
      "#6d1f62",
      "#962d82",
      "#ba43a9",
    ],
    interval='$interval',
    height='50',
    sparklineShow=true,
    prefixFontSize='30%',
    postfixFontSize='30%',
    valueFontSize='30%',
  )
  .addTarget(
    prometheus.target(
      'sum by () (rate(node_vmstat_pgpgout{node_name=~"$host"}[$interval]) or irate(node_vmstat_pgpgout{node_name=~"$host"}[5m])) * 1024',
      intervalFactor = 1,
      interval='$interval',
      calculatedInterval='10m',
      metric='node_mem',
      step=300,
    )
  ),
  gridPos = {
        "h": 3,
        "w": 2,
        "x": 8,
        "y": 17,
  },
  style=null,
)//1302 singlestat
.addPanel(
  singlestat.new(
    'Network IO',//title
    format='Bps',
    decimals=1,
    datasource='Prometheus',
    valueName='current',
    thresholds='',
    colorValue=true,
    colors=[
      "rgba(245, 54, 54, 0.9)",
      "#fce2de",
      "rgba(50, 172, 45, 0.97)",
    ],
    interval='$interval',
    height='50',
    sparklineShow=true,
    prefixFontSize='30%',
    postfixFontSize='30%',
    valueFontSize='30%',
  )
  .addTarget(
    prometheus.target(
      'sum(rate(node_network_receive_bytes_total{node_name=~"$host",device!="lo"}[$interval])
      or irate(node_network_receive_bytes_total{node_name=~"$host",device!="lo"}[5m])
      or max_over_time(rdsosmetrics_network_rx{node_name=~"$host"}[$interval])
      or max_over_time(rdsosmetrics_network_rx{node_name=~"$host"}[5m]))
      +
      sum(rate(node_network_transmit_bytes_total{node_name=~"$host",device!="lo"}[$interval])
      or irate(node_network_transmit_bytes_total{node_name=~"$host",device!="lo"}[5m])
      or max_over_time(rdsosmetrics_network_tx{node_name=~"$host"}[$interval])
      or max_over_time(rdsosmetrics_network_tx{node_name=~"$host"}[5m]))',
      intervalFactor = 1,
      interval='$interval',
      calculatedInterval='10m',
      metric='node_mem',
      step=300,
    )
  ),
  gridPos = {
        "h": 3,
        "w": 2,
        "x": 10,
        "y": 17,
  },
  style=null,
)//1303 singlestat
.addPanel(
  singlestat.new(
    'DB Conns',//title
    format='short',
    datasource='Prometheus',
    valueName='current',
    thresholds='',
    colorValue=false,
    colors=[
      "rgba(245, 54, 54, 0.9)",
       "#7eb26d",
       "rgba(50, 172, 45, 0.97)"
    ],
    interval='$interval',
    height='50',
    sparklineShow=true,
    prefixFontSize='30%',
    postfixFontSize='30%',
    valueFontSize='30%',
    links=[
        {
          "dashUri": "db/mysql-overview",
          "dashboard": "MySQL Overview",
          "includeVars": false,
          "keepTime": true,
          "targetBlank": true,
          "title": "MySQL Overview",
          "type": "dashboard"
        },
        {
          "dashUri": "db/mongodb-overview",
          "dashboard": "MongoDB Overview",
          "includeVars": false,
          "keepTime": true,
          "targetBlank": true,
          "title": "MongoDB Overview",
          "type": "dashboard"
        }
      ],
  )
  .addTarget(
    prometheus.target(
      'sum by () (max_over_time(mysql_global_status_threads_connected{service_name=~"$service"}[$interval]) or
      max_over_time(mongodb_connections{service_name=~"$service",state="current"}[$interval]) or
      sum by (node_name) (max_over_time(pg_stat_database_numbackends{service_name=~"$service"}[$interval])))',
      intervalFactor = 1,
      interval='$interval',
      calculatedInterval='10m',
      metric='node_mem',
      step=300,
    )
  ),
  gridPos = {
        "h": 3,
        "w": 2,
        "x": 12,
        "y": 17,
  },
  style=null,
)//1304 singlestat
.addPanel(
  singlestat.new(
    'DB QPS',//title
    format='short',
    decimals=2,
    datasource='Prometheus',
    valueName='current',
    thresholds='',
    colorValue=false,
    colors=[
      "rgba(245, 54, 54, 0.9)",
       "#7eb26d",
       "rgba(50, 172, 45, 0.97)"
    ],
    interval='$interval',
    height='50',
    sparklineShow=true,
    prefixFontSize='30%',
    postfixFontSize='30%',
    valueFontSize='30%',
  )
  .addTarget(
    prometheus.target(
      'sum by () (\n(rate(mysql_global_status_queries{service_name=~\"$service\"}[$interval]) or \nirate(mysql_global_status_queries{service_name=~\"$service\"}[5m])) or \n(sum(rate(mongodb_mongod_op_counters_total{service_name=~\"$service\",type!=\"command\"}[$interval])) or \nsum(irate(mongodb_mongod_op_counters_total{service_name=~\"$service\",type!=\"command\"}[5m]))) or\n(sum(rate(pg_stat_database_xact_commit{service_name=~\"$service\"}[$interval]) + rate(pg_stat_database_xact_rollback{service_name=~\"$service\"}[$interval])) or\nsum(irate(pg_stat_database_xact_commit{service_name=~\"$service\"}[5m]) + irate(pg_stat_database_xact_rollback{service_name=~\"$service\"}[5m])))\n)',
      intervalFactor = 1,
      interval='$interval',
      calculatedInterval='10m',
      metric='node_mem',
      step=300,
    )
  ),
  gridPos = {
        "h": 3,
        "w": 2,
        "x": 14,
        "y": 17,
  },
  style=null,
)//1305 singlestat
.addPanel(
  singlestat.new(
    'Virtual CPUs',//title
    format='none',
    datasource='Prometheus',
    valueName='current',
    thresholds='',
    colorValue=false,
    colors=[
      "rgba(245, 54, 54, 0.9)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(50, 172, 45, 0.97)"
    ],
    interval='$interval',
    height='20',
    prefixFontSize='50%',
    postfixFontSize='50%',
    valueFontSize='50%',
  )
  .addTarget(
    prometheus.target(
      '(count(node_cpu_seconds_total{node_name=~"$host",mode=~"user"}) or
      (1-absent(node_cpu_seconds_total{node_name=~"$host",mode=~"user"}))) + sum(rdsosmetrics_General_numVCPUs{node_name=~"$host"} or up * 0)',
      intervalFactor = 1,
      interval='$interval',
      instant=true,
      step=300,
    )
  ),
  gridPos = {
        "h": 3,
        "w": 2,
        "x": 16,
        "y": 17,
  },
  style=null,
)//1306 singlestat
.addPanel(
  singlestat.new(
    'RAM',//title
    format='bytes',
    datasource='Prometheus',
    valueName='current',
    decimals=2,
    editable=true,
    thresholds='',
    colorValue=false,
    colors=[
      "rgba(245, 54, 54, 0.9)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(50, 172, 45, 0.97)"
    ],
    interval='$interval',
    height='50',
    prefixFontSize='20%',
    postfixFontSize='20%',
    valueFontSize='30%',
  )
  .addTarget(
    prometheus.target(
      'sum by () (node_memory_MemTotal_bytes{node_name=~"$host"})',
      intervalFactor = 1,
      interval='5m',
      instant=true,
      step=300,
    )
  ),
  gridPos = {
        "h": 3,
        "w": 2,
        "x": 18,
        "y": 17,
  },
  style=null,
)//1307 singlestat
.addPanel(
  singlestat.new(
    'Host uptime',//title
    description="AVG   Uptime for  `All`",
    format='s',
    decimals=1,
    datasource='Prometheus',
    valueName='avg',
    thresholds='3600,86400',
    colorValue=true,
    colors=[
      "rgba(245, 54, 54, 0.9)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(50, 172, 45, 0.97)"
    ],
    interval='$interval',
    height='50',
    postfix='s',
    prefixFontSize='20%',
    postfixFontSize='30%',
    valueFontSize='30%',
  )
  .addTarget(
    prometheus.target(
      'avg(node_time_seconds{node_name=~"$host"} - node_boot_time_seconds{node_name=~"$host"})',
      intervalFactor = 1,
      interval='5m',
      instant=true,
      step=300,
    )
  ),
  gridPos = {
        "h": 3,
        "w": 2,
        "x": 20,
        "y": 17,
  },
  style=null,
)//1308 singlestat
.addPanel(
  singlestat.new(
    'DB uptime',//title
    description="AVG for  `All`",
    format='s',
    decimals=1,
    datasource='Prometheus',
    valueName='current',
    thresholds='3600,86400',
    colorValue=true,
    colors=[
      "rgba(245, 54, 54, 0.9)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(50, 172, 45, 0.97)"
    ],
    interval='$interval',
    height='50',
    postfix='s',
    prefixFontSize='20%',
    postfixFontSize='30%',
    valueFontSize='30%',
  )
  .addTarget(
    prometheus.target(
      'avg(mysql_global_status_uptime{service_name=~"$service"} or
      mongodb_instance_uptime_seconds {service_name=~"$service"} or
      (time() - process_start_time_seconds{service_name=~"$service",job=~"postgres_exporter.*"}))',
      intervalFactor = 1,
      interval='5m',
      step=300,
      calculatedInterval='10m',
    )
  ),
  gridPos = {
        "h": 3,
        "w": 2,
        "x": 22,
        "y": 17,
  },
  style=null,
)//1309 singlestat
.addPanel(
    row.new(
      title='',
      repeat='host',
    ),
    gridPos={
      "h": 1,
       "w": 24,
       "x": 0,
       "y": 20
    },
    style=null,
)//1343 row
.addPanel(
  text.new(
    content='$host',
    mode='markdown',
    title='',
    transparent=true,
    height='50px',
    maxPerRow=12,
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
  ),
  gridPos={
    "h": 3,
     "w": 2,
     "x": 0,
     "y": 21
      },
  style=null,
)//162 text
.addPanel(
  pmmPanel.new(
    '',//title
    format='percent',
    decimals=0,
    datasource='Prometheus',
    valueName='current',
    thresholds='70,90',
    colorValue=true,
    colors=[
      "rgba(50, 172, 45, 0.97)",
     "rgba(237, 129, 40, 0.89)",
     "rgba(245, 54, 54, 0.9)",
    ],
    interval='$interval',
    height='50',
    sparklineShow=true,
    prefixFontSize='80%',
    postfixFontSize='80%',
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
      'clamp_max(avg by (node_name)
      (sum by (cpu) ( (clamp_max(rate(node_cpu_seconds_total{node_name=~"$host",mode!="idle",mode!="iowait"}[$interval]),1)) or
      (clamp_max(irate(node_cpu_seconds_total{node_name=~"$host",mode!="idle",mode!="iowait"}[5m]),1)) )),1) *100 or
      sum by () (
      avg_over_time(node_cpu_average{node_name=~"$host",mode!="idle", mode!="total",job="rds-enhanced"}[$interval]) or
      avg_over_time(node_cpu_average{node_name=~"$host",mode!="idle", mode!="total",job="rds-enhanced"}[5m]))',
      intervalFactor = 1,
      interval='$interval',
      calculatedInterval='10m',
      metric='node_mem',
      step=300,
    )
  ),
  gridPos = {
    "h": 3,
    "w": 2,
    "x": 2,
    "y": 21,
  },
  style=null,
)//163 pmm-singlestat
.addPanel(
  pmmPanel.new(
    '',//title
    format='percent',
    decimals=0,
    datasource='Prometheus',
    valueName='current',
    thresholds='10,20',
    colorValue=true,
    colors=[
      "rgba(245, 54, 54, 0.9)",
       "rgba(237, 129, 40, 0.89)",
       "rgba(50, 172, 45, 0.97)"
    ],
    interval='$interval',
    height='50',
    sparklineShow=true,
    prefixFontSize='80%',
  )
  .addTarget(
    prometheus.target(
      '(node_memory_MemAvailable_bytes{node_name=~"$host"} or
      (node_memory_MemFree_bytes{node_name=~"$host"} + node_memory_Buffers_bytes{node_name=~"$host"} + node_memory_Cached_bytes{node_name=~"$host"})) /
      node_memory_MemTotal_bytes{node_name=~"$host"} * 100',
      intervalFactor = 1,
      interval='$interval',
      calculatedInterval='10m',
      metric='node_mem',
      step=300,
    )
  ),
  gridPos = {
    "h": 3,
    "w": 2,
    "x": 4,
    "y": 21,
  },
  style=null,
)//9 pmm-singlestat
.addPanel(
  singlestat.new(
    '',//title
    format='Bps',
    decimals=1,
    datasource='Prometheus',
    valueName='current',
    thresholds='10000000,100000000',
    colorValue=false,
    colors=[
      "#0a437c",
        "#1f78c1",
        "#5195ce"
    ],
    interval='$interval',
    height='25',
    sparklineFillColor='rgba(224, 249, 215, 0)',
    sparklineShow=true,
    prefixFontSize='30%',
    postfixFontSize='30%',
    valueFontSize='30%',
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
      intervalFactor = 1,
      interval='$interval',
      calculatedInterval='10m',
      metric='node_mem',
      step=300,
    )
  ),
  gridPos = {
    "h": 3,
    "w": 2,
    "x": 6,
    "y": 21,
  },
  style=null,
)//314 singlestat
.addPanel(
  singlestat.new(
    '',//title
    format='Bps',
    decimals=1,
    datasource='Prometheus',
    valueName='current',
    thresholds='10000000,100000000',
    colorValue=false,
    colors=[
      "#6d1f62",
      "#962d82",
      "#ba43a9"
    ],
    interval='$interval',
    height='50',
    sparklineShow=true,
    prefixFontSize='30%',
    postfixFontSize='30%',
    valueFontSize='30%',
  )
  .addTarget(
    prometheus.target(
      'rate(node_vmstat_pgpgout{node_name=~"$host"}[$interval]) * 1024 or irate(node_vmstat_pgpgout{node_name=~"$host"}[5m]) * 1024',
      intervalFactor = 1,
      interval='$interval',
      calculatedInterval='10m',
      metric='node_mem',
      step=300,
    )
  ),
  gridPos = {
    "h": 3,
    "w": 2,
    "x": 8,
    "y": 21,
  },
  style=null,
)//490 singlestat
.addPanel(
  singlestat.new(
    '',//title
    format='Bps',
    decimals=1,
    datasource='Prometheus',
    valueName='current',
    thresholds='',
    colorValue=true,
    colors=[
      "rgba(245, 54, 54, 0.9)",
      "#fce2de",
      "rgba(50, 172, 45, 0.97)"
    ],
    interval='$interval',
    height='50',
    sparklineShow=true,
    prefixFontSize='30%',
    postfixFontSize='30%',
    valueFontSize='30%',
  )
  .addTarget(
    prometheus.target(
      '(sum(rate(node_network_receive_bytes_total{node_name=~"$host", device!="lo"}[$interval]) or
      irate(node_network_receive_bytes_total{node_name=~"$host", device!="lo"}[5m])) or
      sum(max_over_time(rdsosmetrics_network_rx{node_name=~"$host"}[$interval])) or
      sum(max_over_time(rdsosmetrics_network_rx{node_name=~"$host"}[5m]))) +
      (sum(rate(node_network_transmit_bytes_total{node_name=~"$host", device!="lo"}[$interval]) or
      irate(node_network_transmit_bytes_total{node_name=~"$host", device!="lo"}[5m])) or
      sum(max_over_time(rdsosmetrics_network_tx{node_name=~"$host"}[$interval])) or
      sum(max_over_time(rdsosmetrics_network_tx{node_name=~"$host"}[5m])))',
      intervalFactor = 1,
      interval='$interval',
      calculatedInterval='10m',
      metric='node_mem',
      step=300,
    )
  ),
  gridPos = {
    "h": 3,
    "w": 2,
    "x": 10,
    "y": 21,
  },
  style=null,
)//491 singlestat
.addPanel(
  singlestat.new(
    '',//title
    format='short',
    datasource='Prometheus',
    valueName='current',
    thresholds='',
    colorValue=false,
    colors=[
      "rgba(245, 54, 54, 0.9)",
      "#7eb26d",
      "rgba(50, 172, 45, 0.97)"
    ],
    interval='$interval',
    height='50',
    sparklineShow=true,
    prefixFontSize='30%',
    postfixFontSize='30%',
    valueFontSize='30%',
    links=[
        {
          "dashUri": "db/mysql-overview",
          "dashboard": "MySQL Overview",
          "includeVars": true,
          "keepTime": true,
          "targetBlank": true,
          "title": "MySQL Overview",
          "type": "dashboard"
        },
        {
          "dashUri": "db/mongodb-overview",
          "dashboard": "MongoDB Overview",
          "includeVars": true,
          "keepTime": true,
          "targetBlank": true,
          "title": "MongoDB Overview",
          "type": "dashboard"
        },
        {
          "dashboard": "PostgreSQL Overview",
          "includeVars": true,
          "keepTime": true,
          "targetBlank": true,
          "title": "PostgreSQL Overview",
          "type": "dashboard"
        }
      ],
  )
  .addTarget(
    prometheus.target(
      'sum by (node_name) (max_over_time(mysql_global_status_threads_connected{service_name=~"$service",node_name=~"$host"}[$interval]) or
      max_over_time(mongodb_connections{service_name=~"$service",node_name=~"$host",state="current"}[$interval]) or
      sum by (node_name) (max_over_time(pg_stat_database_numbackends{service_name=~"$service",node_name=~"$host"}[$interval])))',
      intervalFactor = 1,
      interval='$interval',
      calculatedInterval='10m',
      metric='node_mem',
      step=300,
    )
  ),
  gridPos = {
    "h": 3,
    "w": 2,
    "x": 12,
    "y": 21,
  },
  style=null,
)//492 singlestat
.addPanel(
  singlestat.new(
    '',//title
    format='short',
    decimals=2,
    editable=true,
    datasource='Prometheus',
    valueName='current',
    thresholds='',
    colorValue=false,
    colors=[
      "rgba(245, 54, 54, 0.9)",
      "#7eb26d",
      "rgba(50, 172, 45, 0.97)"
    ],
    interval='$interval',
    height='50',
    sparklineShow=true,
    prefixFontSize='30%',
    postfixFontSize='30%',
    valueFontSize='30%',
  )
  .addTarget(
    prometheus.target(
      'sum by (node_name) (\n(rate(mysql_global_status_queries{service_name=~\"$service\",node_name=~\"$host\"}[$interval]) or \nirate(mysql_global_status_queries{service_name=~\"$service\",node_name=~\"$host\"}[5m])) or \n(sum by (node_name) (rate(mongodb_mongod_op_counters_total{service_name=~\"$service\",node_name=~\"$host\",type!=\"command\"}[$interval])) or \nsum by (node_name) (irate(mongodb_mongod_op_counters_total{service_name=~\"$service\",node_name=~\"$host\",type!=\"command\"}[5m]))) or\n(sum by (node_name) (rate(pg_stat_database_xact_commit{service_name=~\"$service\",node_name=~\"$host\"}[$interval]) + rate(pg_stat_database_xact_rollback{service_name=~\"$service\",node_name=~\"$host\"}[$interval])) or\nsum by (node_name) (irate(pg_stat_database_xact_commit{service_name=~\"$service\",node_name=~\"$host\"}[5m]) + irate(pg_stat_database_xact_rollback{service_name=~\"$service\",node_name=~\"$host\"}[5m])))\n)',
      intervalFactor = 1,
      interval='$interval',
      calculatedInterval='10m',
      metric='node_mem',
      step=300,
    )
  ),
  gridPos = {
    "h": 3,
    "w": 2,
    "x": 14,
    "y": 21,
  },
  style=null,
)//743 singlestat
.addPanel(
  singlestat.new(
    '',//title
    format='none',
    datasource='Prometheus',
    valueName='current',
    thresholds='',
    colorValue=false,
    colors=[
      "rgba(245, 54, 54, 0.9)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(50, 172, 45, 0.97)"
    ],
    maxPerRow=12,
    interval='$interval',
    height='20',
    prefixFontSize='50%',
    postfixFontSize='50%',
    valueFontSize='50%',
    valueMaps=[
        {
          "op": "=",
          "text": "N/A",
          "value": "null"
        },
        {
          "op": "=",
          "text": "N/A",
          "value": "0"
        }
      ],
  )
  .addTarget(
    prometheus.target(
      '(count(node_cpu_seconds_total{node_name=~"$host",mode=~"user"}) or (1-absent(node_cpu_seconds_total{node_name=~"$host",mode=~"user"}))) +
      sum(rdsosmetrics_General_numVCPUs{node_name=~"$host"} or up * 0)',
      intervalFactor = 1,
      interval='5m',
      step=300,
      instant=true,
    )
  ),
  gridPos = {
    "h": 3,
    "w": 2,
    "x": 16,
    "y": 21,
  },
  style=null,
)//25 singlestat
.addPanel(
  singlestat.new(
    '',//title
    decimals=2,
    format='bytes',
    datasource='Prometheus',
    valueName='current',
    thresholds='',
    colorValue=false,
    colors=[
      "rgba(245, 54, 54, 0.9)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(50, 172, 45, 0.97)"
    ],
    interval='$interval',
    height='50',
    prefixFontSize='20%',
    postfixFontSize='20%',
    valueFontSize='30%',
  )
  .addTarget(
    prometheus.target(
      'node_memory_MemTotal_bytes{node_name=~"$host"}',
      intervalFactor = 1,
      interval='5m',
      step=300,
    )
  ),
  gridPos = {
    "h": 3,
    "w": 2,
    "x": 18,
    "y": 21,
  },
  style=null,
)//26 singlestat
.addPanel(
  singlestat.new(
    '',//title
    decimals=1,
    format='s',
    datasource='Prometheus',
    valueName='current',
    thresholds='300,3600',
    colorValue=true,
    colors=[
      "rgba(245, 54, 54, 0.9)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(50, 172, 45, 0.97)"
    ],
    interval='$interval',
    height='50',
    prefixFontSize='20%',
    postfix='s',
    postfixFontSize='30%',
    valueFontSize='30%',
  )
  .addTarget(
    prometheus.target(
      'node_time_seconds{node_name=~"$host"} - node_boot_time_seconds{node_name=~"$host"}',
      intervalFactor = 1,
      interval='5m',
      calculatedInterval='10m',
      step=300,
    )
  ),
  gridPos = {
    "h": 3,
    "w": 2,
    "x": 20,
    "y": 21,
  },
  style=null,
)//19 singlestat
.addPanel(
  singlestat.new(
    '',//title
    decimals=1,
    format='s',
    datasource='Prometheus',
    valueName='current',
    thresholds='300,3600',
    colorValue=true,
    colors=[
      "rgba(245, 54, 54, 0.9)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(50, 172, 45, 0.97)"
    ],
    interval='$interval',
    height='50',
    prefixFontSize='20%',
    postfix='s',
    postfixFontSize='30%',
    valueFontSize='30%',
  )
  .addTarget(
    prometheus.target(
      'avg by (node_name) (mysql_global_status_uptime{service_name=~"$service",node_name=~"$host"} or
      mongodb_instance_uptime_seconds {service_name=~"$service",node_name=~"$host"} or
      (time() - process_start_time_seconds{service_name=~"$service",node_name=~"$host",job=~"postgres_exporter.*"}))',
      intervalFactor = 1,
      interval='5m',
      calculatedInterval='10m',
      step=300,
    )
  ),
  gridPos = {
    "h": 3,
    "w": 2,
    "x": 22,
    "y": 21,
  },
  style=null,
)//1297 singlestat
