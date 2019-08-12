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
  'MySQL Overview',
  time_from='now-12h',
  editable=false,
  refresh= "1m",
  graphTooltip='shared_crosshair',
  schemaVersion=18,
  version=1,
  tags=['Percona','MySQL'],
  iteration=1565168661742,
  uid="MQWgroiiz",
  timepicker = timepicker.new(
      collapse=false,
      enable=true,
      hidden=false,
      notice=false,
      now=true,
      status='Stable',
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
  'environment',
  'Prometheus',
  'label_values(mysql_up, environment)',
  label='Environment',
  refresh='load',
  sort=0,
  multi=true,
  skipUrlSync=false,
  definition='label_values(mysql_up, environment)',
  includeAll=true,
  tagsQuery='',
  tagValuesQuery='',
  ),
)
.addTemplate(
  template.new(
  'host',
  'Prometheus',
  'label_values(mysql_up{environment=~"$environment"}, node_name)',
  label='Host',
  refresh='load',
  allFormat='glob',
  sort=1,
  hide=2,
  multi=true,
  multiFormat='regex values',
  skipUrlSync=false,
  definition='label_values(mysql_up{environment=~"$environment"}, node_name)',
  includeAll=true,
  tagsQuery='',
  tagValuesQuery='',
  ),
)
.addTemplate(
  template.new(
  'region',
  'Prometheus',
  'label_values(mysql_up{node_name=~"$host"}, region)',
  label='Region',
  refresh='load',
  //allFormat='glob',
  sort=0,
  hide=2,
  multi=false,
  //multiFormat='regex values',
  skipUrlSync=false,
  definition='label_values(mysql_up{node_name=~"$host"}, region)',
  includeAll=false,
  tagsQuery='',
  tagValuesQuery='',
  ),
)
.addTemplate(
  template.new(
  'cluster',
  'Prometheus',
  'label_values(mysql_up{node_name=~"$host"}, cluster)',
  label='Cluster',
  refresh='load',
  //allFormat='glob',
  sort=0,
  hide=2,
  multi=false,
  //multiFormat='regex values',
  skipUrlSync=false,
  definition='label_values(mysql_up{node_name=~"$host"}, cluster)',
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
  allFormat='glob',
  sort=1,
  multi=false,
  multiFormat='regex values',
  skipUrlSync=false,
  definition='label_values(mysql_up{node_name=~"$host"}, service_name)',
  includeAll=false,
  tagsQuery='',
  tagValuesQuery='',
  ),
)
.addTemplate(
  template.new(
  'node_id',
  'Prometheus',
  'label_values(mysql_up{node_name="$host"}, node_id)',
  label='Node_ID',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  definition='label_values(mysql_up{node_name="$host"}, node_id)',
  includeAll=false,
  tagsQuery='',
  tagValuesQuery='',
  ),
)
.addTemplate(
  template.new(
  'agent_id',
  'Prometheus',
  'label_values(mysql_up{node_name="$host"}, instance)',
  label='Agent_ID',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  definition='label_values(mysql_up{node_name="$host"}, instance)',
  includeAll=false,
  tagsQuery='',
  tagValuesQuery='',
  ),
)
.addTemplate(
  template.new(
  'service_id',
  'Prometheus',
  'label_values(mysql_up{service_name=~"$service"}, service_id)',
  label='Service_ID',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  definition='label_values(mysql_up{service_name=~"$service"}, service_id)',
  includeAll=false,
  tagsQuery='',
  tagValuesQuery='',
  ),
)
.addTemplate(
  template.new(
  'az',
  'Prometheus',
  'label_values(mysql_up{node_name="$host"}, az)',
  label='Az',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  definition='label_values(mysql_up{node_name="$host"}, az)',
  includeAll=false,
  tagsQuery='',
  tagValuesQuery='',
  ),
)
.addTemplate(
  template.new(
  'node_type',
  'Prometheus',
  'label_values(mysql_up{node_name="$host"}, node_type)',
  label='Node_type',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  definition='label_values(mysql_up{node_name="$host"}, node_type)',
  includeAll=false,
  tagsQuery='',
  tagValuesQuery='',
  ),
)
.addTemplate(
  template.new(
  'node_model',
  'Prometheus',
  'label_values(mysql_up{node_name="$host"}, node_model)',
  label='Node_model',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  definition='label_values(mysql_up{node_name="$host"}, node_model)',
  includeAll=false,
  tagsQuery='',
  tagValuesQuery='',
  ),
)
.addTemplate(
  template.new(
  'replication_set',
  'Prometheus',
  'label_values(mysql_up{service_name=~"$service"}, replication_set)',
  label='Replication_Set',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  definition='label_values(mysql_up{service_name=~"$service"}, replication_set)',
  includeAll=false,
  tagsQuery='',
  tagValuesQuery='',
  ),
)
.addTemplate(
  template.new(
  'version',
  'Prometheus',
  'label_values(mysql_version_info{service_name=~"$service"},version)',
  refresh='load',
  sort=0,
  hide=2,
  multi=false,
  skipUrlSync=false,
  definition='label_values(mysql_version_info{service_name=~"$service"},version)',
  includeAll=false,
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
)//382 row
.addPanel(
  singlestat.new(
    'MySQL Uptime',//title
    description='**MySQL Uptime**\n\nThe amount of time since the last restart of the MySQL server process.',
    colorPostfix=true,
    colorValue=true,
    format='s',
    editable=true,
    decimals=1,
    datasource='Prometheus',
    valueName='current',
    thresholds='300,3600',
    height='125px',
    colors=[
      "rgba(245, 54, 54, 0.9)",
     "rgba(237, 129, 40, 0.89)",
     "rgba(50, 172, 45, 0.97)"
    ],
    sparklineShow=false,
    interval='',
    prefixFontSize='80%',
    postfixFontSize='80%',
    postfix='s',
    valueFontSize='80%',
    valueMaps=[],
  )
  .addTarget(
    prometheus.target(
      'mysql_global_status_uptime{service_name="$service"}',
      intervalFactor = 1,
      interval='5m',
      calculatedInterval='10m',
      step=300,
    )
  ),
  gridPos={
    "h": 2,
    "w": 4,
    "x": 0,
    "y": 1
  },
  style=null,
)//12 singlestat
.addPanel(
  text.new(
    content='<h2><b><font color=#e68a00><center>$version</center></font></b></h2>\n\n\n',
    mode='html',
    title='Version',
  ),
  gridPos={
      "h": 2,
       "w": 5,
       "x": 4,
       "y": 1
      },
  style=null,
)//401 text
.addPanel(
  singlestat.new(
    'Current QPS',//title
    description="**Current QPS**\n\nBased on the queries reported by MySQL's ``SHOW STATUS`` command, it is the number of statements executed by the server within the last second. This variable includes statements executed within stored programs, unlike the Questions variable. It does not count \n``COM_PING`` or ``COM_STATISTICS`` commands.",
    colorPostfix=false,
    colorValue=false,
    format='short',
    editable=true,
    decimals=2,
    datasource='Prometheus',
    valueName='current',
    thresholds='35,75',
    height='125px',
    colors=[
      "rgba(245, 54, 54, 0.9)",
     "rgba(237, 129, 40, 0.89)",
     "rgba(50, 172, 45, 0.97)"
    ],
    sparklineShow=true,
    interval='$interval',
    prefixFontSize='80%',
    postfixFontSize='50%',
    valueFontSize='80%',
    valueMaps=[],
    links=[
        {
          "targetBlank": true,
          "title": "MySQL Server Status Variables",
          "type": "absolute",
          "url": "https://dev.mysql.com/doc/refman/5.7/en/server-status-variables.html#statvar_Queries"
        }
      ],
  )
  .addTarget(
    prometheus.target(
      'rate(mysql_global_status_queries{service_name="$service"}[$interval]) or irate(mysql_global_status_queries{service_name="$service"}[5m])',
      intervalFactor = 1,
      interval='$interval',
      calculatedInterval='10m',
      step=20,
    )
  ),
  gridPos={
      "h": 2,
       "w": 5,
       "x": 9,
       "y": 1
  },
  style=null,
)//13 singlestat
.addPanel(
  singlestat.new(
    'InnoDB Buffer Pool Size',//title
    description='**InnoDB Buffer Pool Size**\n\nInnoDB maintains a storage area called the buffer pool for caching data and indexes in memory.  Knowing how the InnoDB buffer pool works, and taking advantage of it to keep frequently accessed data in memory, is one of the most important aspects of MySQL tuning. The goal is to keep the working set in memory. In most cases, this should be between 60%-90% of available memory on a dedicated database host, but depends on many factors.',
    colorPostfix=false,
    colorValue=false,
    format='bytes',
    editable=true,
    decimals=0,
    datasource='Prometheus',
    valueName='current',
    thresholds='90,95',
    height='125px',
    colors=[
        "rgba(50, 172, 45, 0.97)",
        "rgba(237, 129, 40, 0.89)",
        "rgba(245, 54, 54, 0.9)"
    ],
    sparklineShow=false,
    interval='$interval',
    prefixFontSize='80%',
    postfixFontSize='50%',
    postfix='',
    valueFontSize='80%',
    valueMaps=[],
    links=[
        {
          "targetBlank": true,
          "title": "Tuning the InnoDB Buffer Pool Size",
          "type": "absolute",
          "url": "https://www.percona.com/blog/2015/06/02/80-ram-tune-innodb_buffer_pool_size/"
        }
      ],
  )
  .addTarget(
    prometheus.target(
      'mysql_global_variables_innodb_buffer_pool_size{service_name="$service"}',
      intervalFactor = 1,
      interval='5m',
      calculatedInterval='10m',
      step=300,
    )
  ),
  gridPos={
      "h": 2,
       "w": 5,
       "x": 14,
       "y": 1
  },
  style=null,
)//51 singlestat
.addPanel(
  pmmSinglestat.new(
    'Buffer Pool Size of Total RAM',//title
    description='**InnoDB Buffer Pool Size % of Total RAM**\n\nInnoDB maintains a storage area called the buffer pool for caching data and indexes in memory.  Knowing how the InnoDB buffer pool works, and taking advantage of it to keep frequently accessed data in memory, is one of the most important aspects of MySQL tuning. The goal is to keep the working set in memory. In most cases, this should be between 60%-90% of available memory on a dedicated database host, but depends on many factors.',
    colorValue=true,
    format='percent',
    decimals=0,
    datasource='Prometheus',
    valueName='current',
    thresholds='40,80',
    height='125px',
    colors=[
      "rgba(245, 54, 54, 0.9)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(50, 172, 45, 0.97)"
    ],
    sparklineShow=true,
    interval='$interval',
    prefixFontSize='80%',
    postfixFontSize='50%',
    postfix='',
    valueFontSize='80%',
    valueMaps=[],
    links=[
        {
          "targetBlank": true,
          "title": "Tuning the InnoDB Buffer Pool Size",
          "type": "absolute",
          "url": "https://www.percona.com/blog/2015/06/02/80-ram-tune-innodb_buffer_pool_size/"
        }
      ],
  )
  .addTarget(
    prometheus.target(
      '(mysql_global_variables_innodb_buffer_pool_size{service_name="$service"} * 100) / on (node_name) node_memory_MemTotal_bytes{node_name="$host"}',
      intervalFactor = 1,
      interval='5m',
      calculatedInterval='10m',
      step=300,
    )
  ),
  gridPos={
      "h": 2,
       "w": 5,
       "x": 19,
       "y": 1
  },
  style=null,
)//52 pmm-singlestat
.addPanel(
    row.new(
      title='Connections',
    )
    ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 3,
    },
    style=null,
)//383 row
.addPanel(
      graphPanel.new(
        'MySQL Connections',//title
        description='**Max Connections** \n\nMax Connections is the maximum permitted number of simultaneous client connections. By default, this is 151. Increasing this value increases the number of file descriptors that mysqld requires. If the required number of descriptors are not available, the server reduces the value of Max Connections.\n\nmysqld actually permits Max Connections + 1 clients to connect. The extra connection is reserved for use by accounts that have the SUPER privilege, such as root.\n\nMax Used Connections is the maximum number of connections that have been in use simultaneously since the server started.\n\nConnections is the number of connection attempts (successful or not) to the MySQL server.',
        fill=2,
        linewidth=2,
        decimals=0,
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
        editable=true,
        height='250px',
        value_type='cumulative',
        min=0,
        links=[
          {
            "targetBlank": true,
            "title": "MySQL Server System Variables",
            "type": "absolute",
            "url": "https://dev.mysql.com/doc/refman/5.7/en/server-system-variables.html#sysvar_max_connections"
          }
        ],
      )
      .addSeriesOverride({
          "alias": "Max Connections",
          "fill": 0
        })
      .addTarget(
          prometheus.target(
            'max(max_over_time(mysql_global_status_threads_connected{service_name="$service"}[$interval]) or
            max_over_time(mysql_global_status_threads_connected{service_name="$service"}[5m]))',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Connections',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_global_status_max_used_connections{service_name="$service"}[$interval]) or
            max_over_time(mysql_global_status_max_used_connections{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Max Used Connections',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_global_variables_max_connections{service_name="$service"}[$interval]) or
            max_over_time(mysql_global_variables_max_connections{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Max Connections',
            calculatedInterval='2m',
            step=20,
          )
      ),
      gridPos={
        "h": 7,
         "w": 12,
         "x": 0,
         "y": 4
      },style=null
)//92 graph
.addPanel(
      graphPanel.new(
        'MySQL Client Thread Activity',//title
        description='**MySQL Active Threads**\n\nThreads Connected is the number of open connections, while Threads Running is the number of threads not sleeping.',
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
        labelY1='Threads',
      )
      .addSeriesOverride({
          "alias": "Peak Threads Running",
          "color": "#E24D42",
          "lines": false,
          "pointradius": 1,
          "points": true
        })
      .addSeriesOverride({
          "alias": "Peak Threads Connected",
          "color": "#1F78C1"
        })
      .addSeriesOverride({
          "alias": "Avg Threads Running",
          "color": "#EAB839"
        })
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_global_status_threads_connected{service_name="$service"}[$interval]) or
            max_over_time(mysql_global_status_threads_connected{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Peak Threads Connected',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_global_status_threads_running{service_name="$service"}[$interval]) or
            max_over_time(mysql_global_status_threads_running{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Peak Threads Running',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'avg_over_time(mysql_global_status_threads_running{service_name="$service"}[$interval]) or
            avg_over_time(mysql_global_status_threads_running{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Avg Threads Running',
            step=20,
          )
      ),
      gridPos={
        "h": 7,
         "w": 12,
         "x": 12,
         "y": 4
      },style=null
)//10 graph
.addPanel(
    row.new(
      title='Table Locks',
    )
    ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 11,
    },
    style=null,
)//384 row
.addPanel(
      graphPanel.new(
        'MySQL Questions',//title
        description="**MySQL Questions**\n\nThe number of statements executed by the server. This includes only statements sent to the server by clients and not statements executed within stored programs, unlike the Queries used in the QPS calculation. \n\nThis variable does not count the following commands:\n* ``COM_PING``\n* ``COM_STATISTICS``\n* ``COM_STMT_PREPARE``\n* ``COM_STMT_CLOSE``\n* ``COM_STMT_RESET``",
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
        links=[
          {
            "targetBlank": true,
            "title": "MySQL Queries and Questions",
            "type": "absolute",
            "url": "https://www.percona.com/blog/2014/05/29/how-mysql-queries-and-questions-are-measured/"
          }
        ],
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_questions{service_name="$service"}[$interval]) or
            irate(mysql_global_status_questions{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Questions',
            calculatedInterval='2m',
          )
      ),
      gridPos={
        "h": 7,
         "w": 12,
         "x": 0,
         "y": 12
      },style=null
)//53 graph
.addPanel(
      graphPanel.new(
        'MySQL Thread Cache',//title
        description="**MySQL Thread Cache**\n\nThe thread_cache_size variable sets how many threads the server should cache to reuse. When a client disconnects, the client's threads are put in the cache if the cache is not full. It is autosized in MySQL 5.6.8 and above (capped to 100). Requests for threads are satisfied by reusing threads taken from the cache if possible, and only when the cache is empty is a new thread created.\n\n* *Threads_created*: The number of threads created to handle connections.\n* *Threads_cached*: The number of threads in the thread cache.",
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
        links=[
          {
            "title": "Tuning information",
            "type": "absolute",
            "url": "https://dev.mysql.com/doc/refman/5.6/en/server-system-variables.html#sysvar_thread_cache_size"
          }
        ],
      )
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_global_variables_thread_cache_size{service_name="$service"}[$interval]) or
            max_over_time(mysql_global_variables_thread_cache_size{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Thread Cache Size',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_global_status_threads_cached{service_name="$service"}[$interval]) or
            max_over_time(mysql_global_status_threads_cached{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Threads Cached',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_threads_created{service_name="$service"}[$interval]) or
            irate(mysql_global_status_threads_created{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Threads Created',
            calculatedInterval='2m',
          )
      ),
      gridPos={
        "h": 7,
         "w": 12,
         "x": 12,
         "y": 12
      },style=null
)//11 graph
.addPanel(
    row.new(
      title='Temporary Objects',
    )
    ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 19,
    },
    style=null,
)//385 row
.addPanel(
      graphPanel.new(
        'MySQL Temporary Objects',//title
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
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_created_tmp_tables{service_name="$service"}[$interval]) or
            irate(mysql_global_status_created_tmp_tables{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Created Tmp Tables',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_created_tmp_disk_tables{service_name="$service"}[$interval]) or
            irate(mysql_global_status_created_tmp_disk_tables{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Created Tmp Disk Tables',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_created_tmp_files{service_name="$service"}[$interval]) or
            irate(mysql_global_status_created_tmp_files{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Created Tmp Files',
            calculatedInterval='2m',
          )
      ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 0,
        "y": 20
      },style=null
)//22 graph
.addPanel(
      graphPanel.new(
        'MySQL Select Types',//title
        description="**MySQL Select Types**\n\nAs with most relational databases, selecting based on indexes is more efficient than scanning an entire table's data. Here we see the counters for selects not done with indexes.\n\n* ***Select Scan*** is how many queries caused full table scans, in which all the data in the table had to be read and either discarded or returned.\n* ***Select Range*** is how many queries used a range scan, which means MySQL scanned all rows in a given range.\n* ***Select Full Join*** is the number of joins that are not joined on an index, this is usually a huge performance hit.",
        fill=2,
        linewidth=2,
        decimals=2,
        datasource='Prometheus',
        height='250px',
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
        legend_hideZero=true,
        editable=true,
        min=0,
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_select_full_join{service_name="$service"}[$interval]) or
            irate(mysql_global_status_select_full_join{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Select Full Join',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_select_full_range_join{service_name="$service"}[$interval]) or
            irate(mysql_global_status_select_full_range_join{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Select Full Range Join',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_select_range{service_name="$service"}[$interval]) or irate(mysql_global_status_select_range{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Select Range',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_select_range_check{service_name="$service"}[$interval]) or
            irate(mysql_global_status_select_range_check{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Select Range Check',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_select_scan{service_name="$service"}[$interval]) or
            irate(mysql_global_status_select_scan{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Select Scan',
            calculatedInterval='2m',
          )
      ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 12,
        "y": 20
      },style=null
)//311 graph
.addPanel(
    row.new(
      title='Sorts',
    )
    ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 27,
    },
    style=null,
)//386 row
.addPanel(
      graphPanel.new(
        'MySQL Sorts',//title
        description="**MySQL Sorts**\n\nDue to a query's structure, order, or other requirements, MySQL sorts the rows before returning them. For example, if a table is ordered 1 to 10 but you want the results reversed, MySQL then has to sort the rows to return 10 to 1.\n\nThis graph also shows when sorts had to scan a whole table or a given range of a table in order to return the results and which could not have been sorted via an index.",
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
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_sort_rows{service_name="$service"}[$interval]) or irate(mysql_global_status_sort_rows{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Sort Rows',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_sort_range{service_name="$service"}[$interval]) or irate(mysql_global_status_sort_range{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Sort Range',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_sort_merge_passes{service_name="$service"}[$interval]) or
            irate(mysql_global_status_sort_merge_passes{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Sort Merge Passes',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_sort_scan{service_name="$service"}[$interval]) or
            irate(mysql_global_status_sort_scan{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Sort Scan',
            calculatedInterval='2m',
          )
      ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 0,
        "y": 28
      },style=null
)//30 graph
.addPanel(
      graphPanel.new(
        'MySQL Slow Queries',//title
        description="**MySQL Slow Queries**\n\nSlow queries are defined as queries being slower than the long_query_time setting. For example, if you have long_query_time set to 3, all queries that take longer than 3 seconds to complete will show on this graph.",
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
        value_type='cumulative',
        min=0,
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_slow_queries{service_name="$service"}[$interval]) or \nirate(mysql_global_status_slow_queries{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Slow Queries',
            calculatedInterval='2m',
          )
      ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 12,
        "y": 28
      },style=null
)//48 graph
.addPanel(
    row.new(
      title='Aborted',
    )
    ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 35,
    },
    style=null,
)//387 row
.addPanel(
      graphPanel.new(
        'MySQL Aborted Connections',//title
        description="**Aborted Connections**\n\nWhen a given host connects to MySQL and the connection is interrupted in the middle (for example due to bad credentials), MySQL keeps that info in a system table (since 5.6 this table is exposed in performance_schema).\n\nIf the amount of failed requests without a successful connection reaches the value of max_connect_errors, mysqld assumes that something is wrong and blocks the host from further connection.\n\nTo allow connections from that host again, you need to issue the ``FLUSH HOSTS`` statement.",
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
        value_type='cumulative',
        min=0,
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_aborted_connects{service_name="$service"}[$interval]) or \nirate(mysql_global_status_aborted_connects{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Aborted Connects (attempts)',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_aborted_clients{service_name="$service"}[$interval]) or \nirate(mysql_global_status_aborted_clients{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Aborted Clients (timeout)',
            calculatedInterval='2m',
          )
      ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 0,
        "y": 36
      },style=null
)//47 graph
.addPanel(
      graphPanel.new(
        'MySQL Table Locks',//title
        description="**Table Locks**\n\nMySQL takes a number of different locks for varying reasons. In this graph we see how many Table level locks MySQL has requested from the storage engine. In the case of InnoDB, many times the locks could actually be row locks as it only takes table level locks in a few specific cases.\n\nIt is most useful to compare Locks Immediate and Locks Waited. If Locks waited is rising, it means you have lock contention. Otherwise, Locks Immediate rising and falling is normal activity.",
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
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_table_locks_immediate{service_name="$service"}[$interval]) or \nirate(mysql_global_status_table_locks_immediate{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Table Locks Immediate',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_table_locks_waited{service_name="$service"}[$interval]) or \nirate(mysql_global_status_table_locks_waited{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Table Locks Waited',
            calculatedInterval='2m',
          )
      ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 12,
        "y": 36
      },style=null
)//32 graph
.addPanel(
    row.new(
      title='Network',
    )
    ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 43,
    },
    style=null,
)//388 row
.addPanel(
      graphPanel.new(
        'MySQL Network Traffic',//title
        description="**MySQL Network Traffic**\n\nHere we can see how much network traffic is generated by MySQL. Outbound is network traffic sent from MySQL and Inbound is network traffic MySQL has received.",
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
        formatY1='Bps',
        formatY2='none',
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_bytes_received{service_name="$service"}[$interval]) or \nirate(mysql_global_status_bytes_received{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Inbound',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_bytes_sent{service_name="$service"}[$interval]) or \nirate(mysql_global_status_bytes_sent{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Outbound',
            calculatedInterval='2m',
          )
      ),
      gridPos={
          "h": 7,
          "w": 12,
          "x": 0,
          "y": 44
      },style=null
)//9 graph
.addPanel(
      graphPanel.new(
        'MySQL Network Usage Hourly',//title
        description="**MySQL Network Usage Hourly**\n\nHere we can see how much network traffic is generated by MySQL per hour. You can use the bar graph to compare data sent by MySQL and data received by MySQL.",
        fill=6,
        linewidth=2,
        bars=true,
        lines=false,
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
        height='250px',
        stack=true,
        timeFrom='24h',
        min=0,
        formatY1='bytes',
        formatY2='none',
      )
      .addTarget(
          prometheus.target(
            'increase(mysql_global_status_bytes_received{service_name="$service"}[1h])',
            interval='1h',
            step=3600,
            intervalFactor=1,
            legendFormat='Received',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'increase(mysql_global_status_bytes_sent{service_name="$service"}[1h])',
            interval='1h',
            step=3600,
            intervalFactor=1,
            legendFormat='Sent',
            calculatedInterval='2m',
          )
      ),
      gridPos={
          "h": 7,
          "w": 12,
          "x": 12,
          "y": 44
      },style=null
)//381 graph
.addPanel(
    row.new(
      title='Memory',
    )
    ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 51,
    },
    style=null,
)//389 row
.addPanel(
      graphPanel.new(
        'MySQL Internal Memory Overview',//title
        description="***System Memory***: Total Memory for the system.\\\n***InnoDB Buffer Pool Data***: InnoDB maintains a storage area called the buffer pool for caching data and indexes in memory.\\\n***TokuDB Cache Size***: Similar in function to the InnoDB Buffer Pool,  TokuDB will allocate 50% of the installed RAM for its own cache.\\\n***Key Buffer Size***: Index blocks for MYISAM tables are buffered and are shared by all threads. key_buffer_size is the size of the buffer used for index blocks.\\\n***Adaptive Hash Index Size***: When InnoDB notices that some index values are being accessed very frequently, it builds a hash index for them in memory on top of B-Tree indexes.\\\n ***Query Cache Size***: The query cache stores the text of a SELECT statement together with the corresponding result that was sent to the client. The query cache has huge scalability problems in that only one thread can do an operation in the query cache at the same time.\\\n***InnoDB Dictionary Size***: The data dictionary is InnoDB \u2018s internal catalog of tables. InnoDB stores the data dictionary on disk, and loads entries into memory while the server is running.\\\n***InnoDB Log Buffer Size***: The MySQL InnoDB log buffer allows transactions to run without having to write the log to disk before the transactions commit.",
        fill=6,
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
        legend_sort='avg',
        legend_sortDesc=true,
        legend_hideEmpty=true,
        legend_hideZero=true,
        legend_rightSide=true,
        editable=true,
        stack=true,
        minY1=0,
        formatY1='bytes',
        links=[
          {
            "title": "Detailed descriptions about metrics",
            "type": "absolute",
            "url": "https://www.percona.com/doc/percona-monitoring-and-management/dashboard.mysql-overview.html#mysql-internal-memory-overview"
          }
        ],
      )
      .addSeriesOverride({
          "alias": "System Memory",
          "fill": 0,
          "stack": false
        })
      .addTarget(
          prometheus.target(
            'max_over_time(node_memory_MemTotal_bytes{node_name="$host"}[$interval]) or
            max_over_time(node_memory_MemTotal_bytes{node_name="$host"}[5m])',
            interval='$interval',
            step=4,
            intervalFactor=1,
            legendFormat='System Memory',
          )
      )
      .addTarget(
          prometheus.target(
            '(max_over_time(mysql_global_status_innodb_page_size{service_name="$service"}[$interval]) or
            max_over_time(mysql_global_status_innodb_page_size{service_name="$service"}[5m])) * on (service_name) (max_over_time(mysql_global_status_buffer_pool_pages{service_name="$service",state="data"}[$interval]) or
            max_over_time(mysql_global_status_buffer_pool_pages{service_name="$service",state="data"}[5m]))',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='InnoDB Buffer Pool Data',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_global_variables_innodb_log_buffer_size{service_name="$service"}[$interval]) or
            max_over_time(mysql_global_variables_innodb_log_buffer_size{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='InnoDB Log Buffer Size',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_global_variables_innodb_additional_mem_pool_size{service_name="$service"}[$interval]) or
            max_over_time(mysql_global_variables_innodb_additional_mem_pool_size{service_name="$service"}[5m])',
            interval='$interval',
            step=40,
            intervalFactor=1,
            legendFormat='InnoDB Additional Memory Pool Size',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_global_status_innodb_mem_dictionary{service_name="$service"}[$interval]) or
            max_over_time(mysql_global_status_innodb_mem_dictionary{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='InnoDB Dictionary Size',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_global_variables_key_buffer_size{service_name="$service"}[$interval]) or
            max_over_time(mysql_global_variables_key_buffer_size{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Key Buffer Size',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_global_variables_query_cache_size{service_name="$service"}[$interval]) or
            max_over_time(mysql_global_variables_query_cache_size{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Query Cache Size',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_global_status_innodb_mem_adaptive_hash{service_name="$service"}[$interval]) or
            max_over_time(mysql_global_status_innodb_mem_adaptive_hash{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Adaptive Hash Index Size',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_global_variables_tokudb_cache_size{service_name="$service"}[$interval]) or
            max_over_time(mysql_global_variables_tokudb_cache_size{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='TokuDB Cache Size',
          )
      ),
      gridPos={
        "h": 7,
       "w": 24,
       "x": 0,
       "y": 52
      },style=null
)//50 graph
.addPanel(
    row.new(
      title='Command, Handlers, Processes',
    )
    ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 59,
    },
    style=null,
)//390 row
.addPanel(
      graphPanel.new(
        'Top Command Counters',//title
        description="**Top Command Counters**\n\nThe Com_{{xxx}} statement counter variables indicate the number of times each xxx statement has been executed. There is one status variable for each type of statement. For example, Com_delete and Com_update count [``DELETE``](https://dev.mysql.com/doc/refman/5.7/en/delete.html) and [``UPDATE``](https://dev.mysql.com/doc/refman/5.7/en/update.html) statements, respectively. Com_delete_multi and Com_update_multi are similar but apply to [``DELETE``](https://dev.mysql.com/doc/refman/5.7/en/delete.html) and [``UPDATE``](https://dev.mysql.com/doc/refman/5.7/en/update.html) statements that use multiple-table syntax.",
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
        legend_rightSide=true,
        editable=true,
        nullPointMode='null as zero',
        min=0,
        links=[
          {
            "title": "Server Status Variables (Com_xxx)",
            "type": "absolute",
            "url": "https://dev.mysql.com/doc/refman/5.7/en/server-status-variables.html#statvar_Com_xxx"
          }
        ],
      )
      .addTarget(
          prometheus.target(
            'topk(5, rate(mysql_global_status_commands_total{service_name="$service"}[$interval])>0) or \nirate(mysql_global_status_commands_total{service_name="$service"}[5m])>0',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Com_{{ command }}',
            calculatedInterval='2m',
          )
      ),
      gridPos={
        "h": 7,
       "w": 24,
       "x": 0,
       "y": 60
      },style=null
)//14 graph
.addPanel(
      graphPanel.new(
        'Top Command Counters Hourly',//title
        description="**Top Command Counters Hourly**\n\nThe Com_{{xxx}} statement counter variables indicate the number of times each xxx statement has been executed. There is one status variable for each type of statement. For example, Com_delete and Com_update count [``DELETE``](https://dev.mysql.com/doc/refman/5.7/en/delete.html) and [``UPDATE``](https://dev.mysql.com/doc/refman/5.7/en/update.html) statements, respectively. Com_delete_multi and Com_update_multi are similar but apply to [``DELETE``](https://dev.mysql.com/doc/refman/5.7/en/delete.html) and [``UPDATE``](https://dev.mysql.com/doc/refman/5.7/en/update.html) statements that use multiple-table syntax.",
        fill=6,
        linewidth=2,
        bars=true,
        lines=false,
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
        legend_rightSide=true,
        editable=true,
        stack=true,
        timeFrom='24h',
        min=0,
        links=[
          {
            "dashboard": "https://dev.mysql.com/doc/refman/5.7/en/server-status-variables.html#statvar_Com_xxx",
            "title": "Server Status Variables (Com_xxx)",
            "type": "absolute",
            "url": "https://dev.mysql.com/doc/refman/5.7/en/server-status-variables.html#statvar_Com_xxx"
          }
        ],
      )
      .addTarget(
          prometheus.target(
            'topk(5, increase(mysql_global_status_commands_total{service_name="$service"}[1h])>0)',
            interval='1h',
            step=3600,
            intervalFactor=1,
            legendFormat='Com_{{ command }}',
            calculatedInterval='2m',
          )
      ),
      gridPos={
        "h": 7,
       "w": 24,
       "x": 0,
       "y": 67
      },style=null
)//39 graph
.addPanel(
      graphPanel.new(
        'MySQL Handlers',//title
        description="**MySQL Handlers**\n\nHandler statistics are internal statistics on how MySQL is selecting, updating, inserting, and modifying rows, tables, and indexes.\n\nThis is in fact the layer between the Storage Engine and MySQL.\n\n* `read_rnd_next` is incremented when the server performs a full table scan and this is a counter you don't really want to see with a high value.\n* `read_key` is incremented when a read is done with an index.\n* `read_next` is incremented when the storage engine is asked to 'read the next index entry'. A high value means a lot of index scans are being done.",
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
        legend_rightSide=true,
        legend_hideZero=true,
        editable=true,
        min=0,
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_handlers_total{service_name="$service", handler!~"commit|rollback|savepoint.*|prepare"}[$interval]) or \nirate(mysql_global_status_handlers_total{service_name="$service", handler!~"commit|rollback|savepoint.*|prepare"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='{{ handler }}',
            calculatedInterval='2m',
          )
      ),
      gridPos={
        "h": 7,
       "w": 24,
       "x": 0,
       "y": 74
      },style=null
)//8 graph
.addPanel(
      graphPanel.new(
        'MySQL Transaction Handlers',//title
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
        legend_rightSide=true,
        legend_hideZero=true,
        editable=true,
        min=0,
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_handlers_total{service_name="$service", handler=~"commit|rollback|savepoint.*|prepare"}[$interval]) or
            irate(mysql_global_status_handlers_total{service_name="$service", handler=~"commit|rollback|savepoint.*|prepare"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='{{ handler }}',
            calculatedInterval='2m',
          )
      ),
      gridPos={
        "h": 7,
       "w": 24,
       "x": 0,
       "y": 81
      },style=null
)//28 graph
.addPanel(
      graphPanel.new(
        'Process States',//title
        fill=0,
        linewidth=2,
        decimals=2,
        datasource='Prometheus',
        pointradius=5,
        paceLength=10,
        legend_values=true,
        legend_min=false,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        legend_rightSide=true,
        legend_hideZero=true,
        editable=true,
        nullPointMode="null as zero",
        min=0,
      )
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_info_schema_threads{service_name="$service"}[$interval]) or \nmax_over_time(mysql_info_schema_threads{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='{{ state }}',
            calculatedInterval='2m',
          )
      ),
      gridPos={
        "h": 7,
       "w": 24,
       "x": 0,
       "y": 88
      },style=null
)//40 graph
.addPanel(
      graphPanel.new(
        'Top Process States Hourly',//title
        fill=6,
        linewidth=2,
        bars=true,
        lines=false,
        decimals=2,
        datasource='Prometheus',
        pointradius=5,
        paceLength=10,
        legend_values=true,
        legend_min=false,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        legend_rightSide=true,
        legend_hideZero=true,
        editable=true,
        stack=true,
        timeFrom='24h',
        min=0,
      )
      .addTarget(
          prometheus.target(
            'topk(5, avg_over_time(mysql_info_schema_threads{service_name="$service"}[1h]))',
            interval='1h',
            step=3600,
            intervalFactor=1,
            legendFormat='{{ state }}',
            calculatedInterval='2m',
          )
      ),
      gridPos={
        "h": 7,
       "w": 24,
       "x": 0,
       "y": 95
      },style=null
)//49 graph
.addPanel(
    row.new(
      title='Query Cache',
    )
    ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 102,
    },
    style=null,
)//391 row
.addPanel(
      graphPanel.new(
        'MySQL Query Cache Memory',//title
        description="**MySQL Query Cache Memory**\n\nThe query cache has huge scalability problems in that only one thread can do an operation in the query cache at the same time. This serialization is true not only for SELECTs, but also for INSERT/UPDATE/DELETE.\n\nThis also means that the larger the `query_cache_size` is set to, the slower those operations become. In concurrent environments, the MySQL Query Cache quickly becomes a contention point, decreasing performance. MariaDB and AWS Aurora have done work to try and eliminate the query cache contention in their flavors of MySQL, while MySQL 8.0 has eliminated the query cache feature.\n\nThe recommended settings for most environments is to set:\n  ``query_cache_type=0``\n  ``query_cache_size=0``\n\nNote that while you can dynamically change these values, to completely remove the contention point you have to restart the database.",
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
        formatY1='bytes',
      )
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_global_status_qcache_free_memory{service_name="$service"}[$interval]) or
            max_over_time(mysql_global_status_qcache_free_memory{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Free Memory',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_global_variables_query_cache_size{service_name=\"$service\"}[$interval]) or\nmax_over_time(mysql_global_variables_query_cache_size{service_name=\"$service\"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Query Cache Size',
            calculatedInterval='2m',
          )
      ),
      gridPos={
        "h": 7,
       "w": 12,
       "x": 0,
       "y": 103
      },style=null
)//46 graph
.addPanel(
      graphPanel.new(
        'MySQL Query Cache Activity',//title
        description="**MySQL Query Cache Activity**\n\nThe query cache has huge scalability problems in that only one thread can do an operation in the query cache at the same time. This serialization is true not only for SELECTs, but also for INSERT/UPDATE/DELETE.\n\nThis also means that the larger the `query_cache_size` is set to, the slower those operations become. In concurrent environments, the MySQL Query Cache quickly becomes a contention point, decreasing performance. MariaDB and AWS Aurora have done work to try and eliminate the query cache contention in their flavors of MySQL, while MySQL 8.0 has eliminated the query cache feature.\n\nThe recommended settings for most environments is to set:\n``query_cache_type=0``\n``query_cache_size=0``\n\nNote that while you can dynamically change these values, to completely remove the contention point you have to restart the database.",
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
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_qcache_hits{node_name="$host"}[$interval]) or irate(mysql_global_status_qcache_hits{node_name="$host"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Hits',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_qcache_inserts{node_name="$host"}[$interval]) or irate(mysql_global_status_qcache_inserts{node_name="$host"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Inserts',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_qcache_not_cached{node_name="$host"}[$interval]) or irate(mysql_global_status_qcache_not_cached{node_name="$host"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Not Cached',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_qcache_lowmem_prunes{service_name="$service"}[$interval]) or \nirate(mysql_global_status_qcache_lowmem_prunes{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Prunes',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_global_status_qcache_queries_in_cache{service_name="$service"}[$interval]) or \nmax_over_time(mysql_global_status_qcache_queries_in_cache{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Queries in Cache',
            calculatedInterval='2m',
          )
      ),
      gridPos={
        "h": 7,
       "w": 12,
       "x": 12,
       "y": 103
      },style=null
)//45 graph
.addPanel(
    row.new(
      title='Files and Tables',
    )
    ,gridPos={
      "h": 1,
      "w": 24,
      "x": 0,
      "y": 110,
    },
    style=null,
)//392 row
.addPanel(
      graphPanel.new(
        'MySQL File Openings',//title
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
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_opened_files{service_name="$service"}[$interval]) or \nirate(mysql_global_status_opened_files{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Openings',
            calculatedInterval='2m',
          )
      ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 0,
        "y": 111
      },style=null
)//43 graph
.addPanel(
      graphPanel.new(
        'MySQL Open Files',//title
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
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_global_status_open_files{service_name="$service"}[$interval]) or \nmax_over_time(mysql_global_status_open_files{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Open Files',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_global_variables_open_files_limit{service_name="$service"}[$interval]) or \nmax_over_time(mysql_global_variables_open_files_limit{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Open Files Limit',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_global_status_innodb_num_open_files{service_name="$service"}[$interval]) or \nmax_over_time(mysql_global_status_innodb_num_open_files{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='InnoDB Open Files',
          )
      ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 12,
        "y": 111
      },style=null
)//41 graph
.addPanel(
    row.new(
      title='Table Openings',
    )
    ,gridPos={
      "h": 1,
      "w": 24,
      "x": 0,
      "y": 118,
    },
    style=null,
)//393 row
.addPanel(
      graphPanel.new(
        'MySQL Table Open Cache Status',//title
        description="**MySQL Table Open Cache Status**\n\nThe recommendation is to set the `table_open_cache_instances` to a loose correlation to virtual CPUs, keeping in mind that more instances means the cache is split more times. If you have a cache set to 500 but it has 10 instances, each cache will only have 50 cached.\n\nThe `table_definition_cache` and `table_open_cache` can be left as default as they are auto-sized MySQL 5.6 and above (ie: do not set them to any value).",
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
        formatY2='percentunit',
      )
      .addSeriesOverride({
          "alias": "Table Open Cache Hit Ratio",
          "yaxis": 2
        })
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_opened_tables{service_name="$service"}[$interval]) or \nirate(mysql_global_status_opened_tables{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Openings',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_table_open_cache_hits{service_name="$service"}[$interval]) or \nirate(mysql_global_status_table_open_cache_hits{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Hits',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_table_open_cache_misses{service_name="$service"}[$interval]) or \nirate(mysql_global_status_table_open_cache_misses{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Misses',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_table_open_cache_overflows{service_name="$service"}[$interval]) or \nirate(mysql_global_status_table_open_cache_overflows{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Misses due to Overflows',
          )
      )
      .addTarget(
          prometheus.target(
            '(rate(mysql_global_status_table_open_cache_hits{service_name="$service"}[$interval]) or
            irate(mysql_global_status_table_open_cache_hits{service_name="$service"}[5m]))/
            ((rate(mysql_global_status_table_open_cache_hits{service_name="$service"}[$interval]) or
            irate(mysql_global_status_table_open_cache_hits{service_name="$service"}[5m]))+
            (rate(mysql_global_status_table_open_cache_misses{service_name="$service"}[$interval]) or
            irate(mysql_global_status_table_open_cache_misses{service_name="$service"}[5m])))',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Table Open Cache Hit Ratio',
          )
      ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 0,
        "y": 119
      },style=null
)//44 graph
.addPanel(
      graphPanel.new(
        'MySQL Open Tables',//title
        description="**MySQL Open Tables**\n\nThe recommendation is to set the `table_open_cache_instances` to a loose correlation to virtual CPUs, keeping in mind that more instances means the cache is split more times. If you have a cache set to 500 but it has 10 instances, each cache will only have 50 cached.\n\nThe `table_definition_cache` and `table_open_cache` can be left as default as they are auto-sized MySQL 5.6 and above (ie: do not set them to any value).",
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
        links=[
          {
            "title": "Server Status Variables (table_open_cache)",
            "type": "absolute",
            "url": "http://dev.mysql.com/doc/refman/5.6/en/server-system-variables.html#sysvar_table_open_cache"
          }
        ],
      )
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_global_status_open_tables{service_name="$service"}[$interval]) or\nmax_over_time(mysql_global_status_open_tables{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Open Tables',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_global_variables_table_open_cache{service_name="$service"}[$interval]) or\nmax_over_time(mysql_global_variables_table_open_cache{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Table Open Cache',
            calculatedInterval='2m',
          )
      ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 12,
        "y": 119
      },style=null
)//42 graph
.addPanel(
    row.new(
      title='MySQL Table Definition Cache',
    )
    ,gridPos={
      "h": 1,
      "w": 24,
      "x": 0,
      "y": 126,
    },
    style=null,
)//394 row
.addPanel(
      graphPanel.new(
        'MySQL Table Definition Cache',//title
        description="**MySQL Table Definition Cache**\n\nThe recommendation is to set the `table_open_cache_instances` to a loose correlation to virtual CPUs, keeping in mind that more instances means the cache is split more times. If you have a cache set to 500 but it has 10 instances, each cache will only have 50 cached.\n\nThe `table_definition_cache` and `table_open_cache` can be left as default as they are auto-sized MySQL 5.6 and above (ie: do not set them to any value).",
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
        links=[
          {
            "title": "Server Status Variables (table_open_cache)",
            "type": "absolute",
            "url": "http://dev.mysql.com/doc/refman/5.6/en/server-system-variables.html#sysvar_table_open_cache"
          }
        ],
      )
      .addSeriesOverride({
          "alias": "Opened Table Definitions",
          "yaxis": 2
        })
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_global_status_open_table_definitions{service_name="$service"}[$interval]) or\nmax_over_time(mysql_global_status_open_table_definitions{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Open Table Definitions',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_global_variables_table_definition_cache{service_name="$service"}[$interval]) or\nmax_over_time(mysql_global_variables_table_definition_cache{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Table Definitions Cache Size',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_opened_table_definitions{service_name="$service"}[$interval]) or \nirate(mysql_global_status_opened_table_definitions{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Opened Table Definitions',
          )
      ),
      gridPos={
        "h": 7,
        "w": 24,
        "x": 0,
        "y": 127
      },style=null
)//54 graph
.addPanel(
    row.new(
      title='System Charts',
      collapse=true,
    )
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
            min=0,
            formatY1='Bps',
            formatY2='bytes',
          )
          .addTarget(
              prometheus.target(
                'rate(node_vmstat_pgpgin{node_name="$host"}[$interval]) * 1024 or irate(node_vmstat_pgpgin{node_name="$host"}[5m]) * 1024',
                interval='$interval',
                step=20,
                intervalFactor=1,
                legendFormat='Page In',
                calculatedInterval='2s',
              )
          )
          .addTarget(
              prometheus.target(
                'rate(node_vmstat_pgpgout{node_name="$host"}[$interval]) * 1024 or irate(node_vmstat_pgpgout{node_name="$host"}[5m]) * 1024',
                interval='$interval',
                step=20,
                intervalFactor=1,
                legendFormat='Page Out',
                calculatedInterval='2s',
              )
          ),
          gridPos={
            "h": 7,
            "w": 12,
            "x": 0,
            "y": 140
          }
    )//31 graph
    .addPanel(
          graphPanel.new(
            'Memory Distribution',//title
            fill=6,
            linewidth=2,
            decimals=null,
            datasource='Prometheus',
            pointradius=5,
            paceLength=10,
            height='250px',
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
          )
          .addTarget(
              prometheus.target(
                'max(node_memory_MemTotal_bytes{node_name="$host"}) without(job) -
                (max(node_memory_MemFree_bytes{node_name="$host"}) without(job) +
                max(node_memory_Buffers_bytes{node_name="$host"}) without(job) +
                (max(node_memory_Cached_bytes{node_name="$host",job=~"rds-enhanced|node_exporter_.*"}) without (job) or
                max(node_memory_Cached_bytes{node_name="$host",job="rds-basic"}) without (job)))',
                interval='$interval',
                step=20,
                intervalFactor=1,
                legendFormat='Used',
                calculatedInterval='2s',
              )
          )
          .addTarget(
              prometheus.target(
                'max_over_time(node_memory_MemFree_bytes{node_name="$host"}[$interval]) or\nmax_over_time(node_memory_MemFree_bytes{node_name="$host"}[5m])',
                interval='$interval',
                step=20,
                intervalFactor=1,
                legendFormat='Free',
                calculatedInterval='2s',
              )
          )
          .addTarget(
              prometheus.target(
                'max_over_time(node_memory_Buffers_bytes{node_name="$host"}[$interval]) or\nmax_over_time(node_memory_Buffers_bytes{node_name="$host"}[5m])',
                interval='$interval',
                step=20,
                intervalFactor=1,
                legendFormat='Buffers',
                calculatedInterval='2s',
              )
          )
          .addTarget(
              prometheus.target(
                'max(node_memory_Cached_bytes{node_name="$host",job=~"rds-enhanced|node_exporter_.*"}) without (job) or \nmax(node_memory_Cached_bytes{node_name="$host",job=~"rds-basic"}) without (job)',
                interval='$interval',
                step=20,
                intervalFactor=1,
                legendFormat='Cached',
                calculatedInterval='2s',
              )
          ),
          gridPos={
            "h": 7,
            "w": 12,
            "x": 12,
            "y": 140
          }
    )//37 graph
    .addPanel(
          graphPanel.new(
            'CPU Usage / Load',//title
            fill=6,
            linewidth=2,
            decimals=null,
            datasource='Prometheus',
            pointradius=5,
            paceLength=10,
            height='',
            legend_values=true,
            legend_min=true,
            legend_max=true,
            legend_avg=true,
            legend_alignAsTable=true,
            legend_show=true,
            legend_sort='avg',
            legend_sortDesc=true,
            legend_hideZero=true,
            legend_hideEmpty=true,
            legend_rightSide=true,
            editable=true,
            stack=true,
            min=0,
            maxY1=100,
            decimalsY1=1,
            formatY1='percent',
            formatY2='none',
            aliasColors={
              "Load 1m": "#58140C",
              "Max Core Utilization": "#bf1b00",
              "iowait": "#e24d42",
              "nice": "#1f78c1",
              "softirq": "#806eb7",
              "system": "#eab839",
              "user": "#508642"
            },
            )
          .addSeriesOverride({
              "alias": "Max Core Utilization",
              "lines": false,
              "pointradius": 1,
              "points": true,
              "stack": false
            })
          .addSeriesOverride({
              "alias": "Load 1m",
              "color": "#58140C",
              "fill": 2,
              "legend": false,
              "stack": false,
              "yaxis": 2
            })
          .addTarget(
              prometheus.target(
                'clamp_max(((avg by (mode) ( (clamp_max(rate(node_cpu_seconds_total{node_name="$host",mode!="idle"}[$interval]),1)) or
                (clamp_max(irate(node_cpu_seconds_total{node_name="$host",mode!="idle"}[5m]),1)) ))*100 or
                (avg_over_time(node_cpu_average{node_name=~"$host", mode!="total", mode!="idle"}[$interval]) or
                avg_over_time(node_cpu_average{node_name=~"$host", mode!="total", mode!="idle"}[5m]))),100)',
                interval='$interval',
                step=20,
                intervalFactor=1,
                legendFormat='{{ mode }}',
                calculatedInterval='2s',
              )
          )
          .addTarget(
              prometheus.target(
                'clamp_max(max by () (sum  by (cpu) ( (clamp_max(rate(node_cpu_seconds_total{node_name="$host",mode!="idle",mode!="iowait"}[$interval]),1)) \nor (clamp_max(irate(node_cpu_seconds_total{node_name="$host",mode!="idle",mode!="iowait"}[5m]),1)) ))*100,100)',
                interval='$interval',
                step=20,
                intervalFactor=1,
                legendFormat='Max Core Utilization',
                hide=true,
              )
          )
          .addTarget(
              prometheus.target(
                'max_over_time(node_load1{node_name="$host"}[$interval]) or\nmax_over_time(node_load1{node_name="$host"}[5m])',
                interval='$interval',
                intervalFactor=1,
                legendFormat='Load 1m',
              )
          ),
          gridPos={
            "h": 7,
            "w": 12,
            "x": 0,
            "y": 147
          }
    )//2 graph
    .addPanel(
          graphPanel.new(
            'Disk Latency',//title
            fill=2,
            linewidth=2,
            points=true,
            lines=false,
            decimals=2,
            datasource='Prometheus',
            pointradius=1,
            paceLength=10,
            height='250px',
            legend_values=true,
            legend_min=true,
            legend_max=true,
            legend_avg=true,
            legend_alignAsTable=true,
            legend_show=true,
            legend_sort='avg',
            legend_sortDesc=true,
            legend_hideZero=true,
            legend_hideEmpty=true,
            editable=true,
            minY2=0,
            logBase1Y=2,
            format='s',
            )
          .addTarget(
              prometheus.target(
                'sum((rate(node_disk_read_time_seconds_total{device!~"dm-.+", node_name="$host"}[$interval]) /
                rate(node_disk_reads_completed_total{device!~"dm-.+", node_name="$host"}[$interval])) or
                (irate(node_disk_read_time_seconds_total{device!~"dm-.+", node_name="$host"}[5m]) /
                irate(node_disk_reads_completed_total{device!~"dm-.+", node_name="$host"}[5m]))
                or avg_over_time(aws_rds_read_latency_average{node_name="$host"}[$interval])/1000 or
                avg_over_time(aws_rds_read_latency_average{node_name="$host"}[5m])/1000)',
                interval='$interval',
                step=20,
                intervalFactor=1,
                legendFormat='Read',
                calculatedInterval='2m',
              )
          )
          .addTarget(
              prometheus.target(
                'sum((rate(node_disk_write_time_seconds_total{device!~"dm-.+", node_name="$host"}[$interval]) /
                rate(node_disk_writes_completed_total{device!~"dm-.+", node_name="$host"}[$interval])) or
                (irate(node_disk_write_time_seconds_total{device!~"dm-.+", node_name="$host"}[5m]) /
                irate(node_disk_writes_completed_total{device!~"dm-.+", node_name="$host"}[5m])) or
                avg_over_time(aws_rds_write_latency_average{node_name="$host"}[$interval])/1000 or
                avg_over_time(aws_rds_write_latency_average{node_name="$host"}[5m])/1000)',
                interval='$interval',
                step=20,
                intervalFactor=1,
                legendFormat='Write',
                calculatedInterval='2m',
              )
          ),
          gridPos={
            "h": 7,
            "w": 12,
            "x": 12,
            "y": 147
          }
    )//36 graph
    .addPanel(
          graphPanel.new(
            'Network Traffic',//title
            fill=2,
            linewidth=2,
            decimals=null,
            datasource='Prometheus',
            pointradius=5,
            paceLength=10,
            height='250px',
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
            labelY1="Outbound (-) / Inbound (+)",
            formatY1='Bps',
            formatY2='bytes',
            )
          .addSeriesOverride({
              "alias": "Outbound",
              "transform": "negative-Y"
            })
          .addTarget(
              prometheus.target(
                'sum(rate(node_network_receive_bytes_total{node_name="$host", device!="lo"}[$interval])) or
                sum(irate(node_network_receive_bytes_total{node_name="$host", device!="lo"}[5m])) or
                sum(max_over_time(rdsosmetrics_network_rx{node_name="$host"}[$interval])) or
                sum(max_over_time(rdsosmetrics_network_rx{node_name="$host"}[5m]))',
                interval='$interval',
                step=20,
                intervalFactor=1,
                legendFormat='Inbound',
                calculatedInterval='2s',
              )
          )
          .addTarget(
              prometheus.target(
                'sum(rate(node_network_transmit_bytes_total{node_name="$host", device!="lo"}[$interval])) or
                sum(irate(node_network_transmit_bytes_total{node_name="$host", device!="lo"}[5m])) or
                sum(max_over_time(rdsosmetrics_network_tx{node_name="$host"}[$interval])) or
                sum(max_over_time(rdsosmetrics_network_tx{node_name="$host"}[5m]))',
                interval='$interval',
                step=20,
                intervalFactor=1,
                legendFormat='Outbound',
                calculatedInterval='2s',
              )
          ),
          gridPos={
            "h": 7,
            "w": 12,
            "x": 0,
            "y": 154
          }
    )//21 graph
    .addPanel(
          graphPanel.new(
            'Swap Activity',//title
            fill=2,
            linewidth=2,
            decimals=null,
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
            formatY1='Bps',
            formatY2='bytes',
            )
          .addTarget(
              prometheus.target(
                'rate(node_vmstat_pswpin{node_name="$host"}[$interval]) * 4096 or \nirate(node_vmstat_pswpin{node_name="$host"}[5m]) * 4096',
                interval='$interval',
                step=20,
                intervalFactor=1,
                legendFormat='Swap In (Reads)',
                calculatedInterval='2s',
              )
          )
          .addTarget(
              prometheus.target(
                'rate(node_vmstat_pswpout{node_name="$host"}[$interval]) * 4096 or \nirate(node_vmstat_pswpout{node_name="$host"}[5m]) * 4096',
                interval='$interval',
                step=20,
                intervalFactor=1,
                legendFormat='Swap Out (Writes)',
                calculatedInterval='2s',
              )
          ),
          gridPos={
            "h": 7,
            "w": 12,
            "x": 12,
            "y": 154
          }
    )//36 graph
    ,gridPos={
      "h": 1,
      "w": 24,
      "x": 0,
      "y": 134
    },
    style=null,
)//394 row
.addPanel(
    row.new(
      title='Inventory',
      collapse=true,
    )
    .addPanel(
      text.new(
        content="<table style=\"width:100%; border: 2px solid grey;\">\n  <tr><td></td><td></td><td></td><td></td></tr>\n  <tr><td><font color=#66ffff> Region </font></td><td><a href=\"/graph/d/qyzrQGHmk/system-overview?var-region=${region}\">${region} (${az})</a></td><td><font color=#66ffff> Environment </font></td><td>${environment}</td></tr>\n  <tr><td><font color=#66ffff> Cluster </font></td><td>${cluster}</td>\n  <td><font color=#66ffff> Replication Set </font></td><td><a href=\"/graph/d/_9zrwMHmk/mysql-replication?var-replication_set=${replication_set}\">${replication_set}</td></tr>\n  <tr><td> </td><td> </td><td></td><td></td></tr>\n</table>\n\n",
        mode='html',
        title='',
      )
      .addTarget(
          prometheus.target(
            '',
            format='table',
            intervalFactor=1,
          )
      ),
      gridPos={
          "h": 4,
          "w": 24,
          "x": 0,
          "y": 1
          }
    )//397 text
    ,gridPos={
      "h": 1,
       "w": 24,
       "x": 0,
       "y": 135
    },
    style=null,
)//399 row
