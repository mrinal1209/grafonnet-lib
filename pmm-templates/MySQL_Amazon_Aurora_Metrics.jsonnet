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
  'MySQL Amazon Aurora Metrics',
  time_from='now-12h',
  editable=true,
  refresh= "1m",
  graphTooltip='shared_crosshair',
  schemaVersion=18,
  version=3,
  tags=['Percona','MySQL'],
  iteration=1552407765727,
  uid="SokrwMHmz",
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
  'label_values(mysql_global_variables_aurora_lab_mode, node_name)',
  label='Host',
  refresh='load',
  sort=1,
  allFormat='glob',
  multiFormat='regex values',
  multi=false,
  skipUrlSync=false,
  definition='label_values(mysql_global_variables_aurora_lab_mode, node_name)',
  includeAll=false,
  ),
)
.addTemplate(
  template.new(
  'service',
  'Prometheus',
  'label_values(mysql_global_variables_aurora_lab_mode{node_name=~"$host"}, service_name)',
  label='Service',
  refresh='load',
  sort=0,
  multi=false,
  skipUrlSync=false,
  includeAll=false,
  definition='label_values(mysql_global_variables_aurora_lab_mode{node_name=~"$host"}, service_name)',
  ),
)
.addPanel(
  graphPanel.new(
    'Amazon Aurora Transaction Commits',//title
    description='This graph shows the number of Commits which Amazon Aurora engine performed as well as average commit latency. Graph Latency does not always correlate with the number of performed commits and can be quite high in certain situations.

    * **Number of Amazon Aurora Commits**: The average number of commit operations per second.

    * **Amazon Aurora Commit avg Latency**: The average amount of latency for commit operations',
    fill=2,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    paceLength=10,
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_rightSide=false,
    legend_show=true,
    legend_sortDesc=true,
    legend_sort='avg',
    editable=true,
    min=0,
    formatY1='ops',
    formatY2='µs',
    aliasColors={
        "Amazon Aurora Commit avg Latency": "#962d82",
        "Number of Amazon Aurora Commits ": "#0a50a1",
        "Write Transactions": "#e24d42"
      },
  )
  .addSeriesOverride(
        {
          "alias": "Key Reads",
          "fill": 0
        }
  )
  .addSeriesOverride(
     {
        "alias": "Key Writes",
        "fill": 0,
        "transform": "negative-Y"
      }
  )
  .addSeriesOverride(
   {
      "alias": "Key Write Requests",
      "transform": "negative-Y"
    }
  )
  .addSeriesOverride(
        {
          "alias": "Avg Write Transactions Latency",
          "yaxis": 2
        }
  )
  .addSeriesOverride(
      {
         "alias": "Amazon Aurora Commit avg Latency",
         "yaxis": 2
       }
  )
  .addTarget(
      prometheus.target(
        'rate(mysql_global_status_auroradb_commits{service_name="$service"}[$interval]) or irate(mysql_global_status_auroradb_commits{service_name="$service"}[5m])',
        refId='D',
        interval='$interval',
        calculatedInterval='2m',
        step=300,
        intervalFactor=1,
        legendFormat='Number of Amazon Aurora Commits',
      )
  )
  .addTarget(
      prometheus.target(
        'rate(mysql_global_status_auroradb_commit_latency{service_name="$service"}[$interval])/rate(mysql_global_status_auroradb_commits{service_name="$service"}[$interval]) or irate(mysql_global_status_auroradb_commit_latency{service_name="$service"}[5m])/irate(mysql_global_status_auroradb_commits{service_name="$service"}[5m])',
        refId='A',
        interval='$interval',
        calculatedInterval='2m',
        step=300,
        legendFormat='Amazon Aurora Commit avg Latency',
        intervalFactor=1,
      )
  ),
  gridPos={
    "h": 8,
    "w": 12,
    "x": 0,
    "y": 0,
   },
  style=null,
)//3 graph
.addPanel(
  graphPanel.new(
    'Amazon Aurora Load',//title
    description='This graph shows us what statements contribute most load on the system as well as what load corresponds to Amazon Aurora transaction commit.

    * **Write Transaction Commit Load**: Load in Average Active Sessions per second for COMMIT operations

    * **UPDATE load**: Load in Average Active Sessions per second for UPDATE queries

    * **SELECT load**: Load in Average Active Sessions per second for SELECT queries

    * **DELETE load**: Load in Average Active Sessions per second for DELETE queries

    * **INSERT load**: Load in Average Active Sessions per second for INSERT queries

    An *active session* is a connection that has submitted work to the database engine and is waiting for a response from it. For example, if you submit an SQL query to the database engine, the database session is active while the database engine is processing that query.',
    fill=2,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    paceLength=10,
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_rightSide=false,
    legend_show=true,
    legend_sortDesc=true,
    legend_sort='avg',
    editable=true,
    min=0,
    aliasColors={
        "DDL Load": "#962d82",
        "DELETE load": "#eab839",
        "INSERT load": "#0a437c",
        "SELECT load ": "#629e51",
        "UPDATE load": "#ea6460",
        "Write Transaction Commit Load": "#bf1b00"
      },
  )
  .addSeriesOverride(
   {
      "alias": "Key Blocks Not Flushed",
      "fill": 0
    }
  )
  .addTarget(
      prometheus.target(
        'rate(mysql_global_status_auroradb_commit_latency{service_name="$service"}[$interval])/1000000 or irate(mysql_global_status_auroradb_commit_latency{service_name="$service"}[5m])/1000000',
        refId='C',
        interval='$interval',
        calculatedInterval='2m',
        step=300,
        intervalFactor=1,
        legendFormat='Write Transaction Commit Load',
      )
  )
  .addTarget(
      prometheus.target(
        'rate(mysql_global_status_auroradb_ddl_stmt_duration{service_name="$service"}[$interval])/1000000 or irate(mysql_global_status_auroradb_ddl_stmt_duration{service_name="$service"}[5m])/1000000',
        refId='A',
        interval='$interval',
        legendFormat='DDL Load',
        intervalFactor=1,
      )
  )
  .addTarget(
      prometheus.target(
        'rate(mysql_global_status_auroradb_select_stmt_duration{service_name="$service"}[$interval])/1000000 or irate(mysql_global_status_auroradb_select_stmt_duration{service_name="$service"}[5m])/1000000',
        refId='B',
        interval='$interval',
        legendFormat='SELECT Load',
        intervalFactor=1,
      )
  )
  .addTarget(
      prometheus.target(
        'rate(mysql_global_status_auroradb_insert_stmt_duration{service_name="$service"}[$interval])/1000000 or irate(mysql_global_status_auroradb_insert_stmt_duration{service_name="$service"}[5m])/1000000',
        refId='D',
        interval='$interval',
        legendFormat='INSERT Load',
        intervalFactor=1,
      )
  )
  .addTarget(
      prometheus.target(
        'rate(mysql_global_status_auroradb_update_stmt_duration{service_name="$service"}[$interval])/1000000 or irate(mysql_global_status_auroradb_update_stmt_duration{service_name="$service"}[5m])/1000000',
        refId='E',
        interval='$interval',
        legendFormat='UPDATE Load',
        intervalFactor=1,
      )
  )
  .addTarget(
      prometheus.target(
        'rate(mysql_global_status_auroradb_delete_stmt_duration{service_name="$service"}[$interval])/1000000 or irate(mysql_global_status_auroradb_delete_stmt_duration{service_name="$service"}[5m])/1000000',
        refId='F',
        interval='$interval',
        legendFormat='DELETE Load',
        intervalFactor=1,
      )
  ),
  gridPos={
    "h": 8,
    "w": 12,
    "x": 12,
    "y": 0,
   },
  style=null,
)//21 graph
.addPanel(
  graphPanel.new(
    'Aurora Memory Used',//title
    description='This graph shows how much memory is used by Amazon Aurora lock manager as well as amount of memory used by Amazon Aurora to store Data Dictionary.

    * **Aurora Lock Manager Memory**: the amount of memory used by the Lock Manager, the module responsible for handling row lock requests for concurrent transactions.

    * **Aurora Dictionary Memory**: the amount of memory used by the Dictionary, the space that contains metadata used to keep track of database objects, such as tables and indexes.',
    fill=2,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    paceLength=10,
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_rightSide=false,
    legend_show=true,
    legend_sortDesc=true,
    legend_sort='avg',
    editable=true,
    min=0,
    formatY1='bytes',
  )
  .addSeriesOverride(
      {
         "alias": "Key Reads",
         "fill": 0
       }
  )
  .addSeriesOverride(
      {
          "alias": "Key Writes",
          "fill": 0,
          "transform": "negative-Y"
        }
  )
  .addSeriesOverride(
    {
      "alias": "Key Write Requests",
      "transform": "negative-Y"
    }
  )
  .addTarget(
      prometheus.target(
        'mysql_global_status_aurora_lockmgr_memory_used{service_name="$service"}',
        refId='D',
        interval='$interval',
        calculatedInterval='2m',
        step=300,
        intervalFactor=1,
        legendFormat='Aurora Lock Manager Memory',
      )
  )
  .addTarget(
      prometheus.target(
        'mysql_global_status_aurora_dict_sys_mem_size{service_name="$service"}',
        refId='A',
        interval='$interval',
        calculatedInterval='2m',
        step=300,
        intervalFactor=1,
        legendFormat='Aurora Dictionary Memory ',
      )
  ),
  gridPos={
      "h": 9,
       "w": 12,
       "x": 0,
       "y": 8,
   },
  style=null,
)//22 graph
.addPanel(
  graphPanel.new(
    'Amazon Aurora Statement Latency',//title
    description='This graph shows average latency for the most important types of statements. Latency spikes are often indicative of the instance overload.

    * **DDL Latency:** Average time to execute DDL queries

    * **DELETE Latency**: Average time to execute DELETE queries

    * **UPDATE Latency**: Average time to execute UPDATE queries

    * **SELECT Latency**: Average time to execute SELECT queries

    * **INSERT Latency**: Average time to execute INSERT queries',
    fill=1,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    paceLength=10,
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_rightSide=false,
    legend_show=true,
    legend_sortDesc=true,
    legend_sort='avg',
    editable=true,
    min=0,
    formatY1='µs',
    aliasColors={
               "DDL Latency": "#962d82",
               "DDL Load": "#962d82",
               "DELETE Latency": "#e5ac0e",
               "DELETE load": "#eab839",
               "INSERT Latency": "#0a437c",
               "INSERT load": "#0a437c",
               "SELECT Latency": "#508642",
               "SELECT load ": "#629e51",
               "UPDATE load": "#ea6460",
               "Write Transaction Commit Load": "#bf1b00"
           },
  )
  .addSeriesOverride(
      {
          "alias": "Key Blocks Not Flushed",
          "fill": 0
        }
  )
  .addTarget(
      prometheus.target(
        '(rate(mysql_global_status_auroradb_ddl_stmt_duration{service_name=\"$service\"}[$interval])/ (sum(rate(mysql_global_status_commands_total{service_name=\"$service\",command=~"alter_table|create_index|drop_index|drop_table"}[$interval])) without(command)))',
        refId='A',
        interval='$interval',
        intervalFactor=1,
        legendFormat='DDL Latency',
      )
  )
  .addTarget(
      prometheus.target(
        '(rate(mysql_global_status_auroradb_select_stmt_duration{service_name="$service"}[$interval])/ (sum(rate(mysql_global_status_commands_total{service_name="$service",command="select"}[$interval])) without(command))+rate(mysql_global_status_qcache_hits{service_name="$service"}[$interval]))',
        refId='B',
        interval='$interval',
        intervalFactor=1,
        legendFormat='SELECT Latency',
      )
  )
  .addTarget(
      prometheus.target(
        '(rate(mysql_global_status_auroradb_insert_stmt_duration{service_name="$service"}[$interval])/ (sum(rate(mysql_global_status_commands_total{service_name="$service",command=~"insert|insert_select"}[$interval])) without(command)))',
        refId='D',
        interval='$interval',
        intervalFactor=1,
        legendFormat='INSERT Latency',
      )
  )
  .addTarget(
      prometheus.target(
        '(rate(mysql_global_status_auroradb_update_stmt_duration{service_name="$service"}[$interval])/ (sum(rate(mysql_global_status_commands_total{service_name="$service",command=~"update|update_multi"}[$interval])) without(command)))',
        refId='E',
        interval='$interval',
        intervalFactor=1,
        legendFormat='UPDATE Latency',
      )
  )
  .addTarget(
      prometheus.target(
        '(rate(mysql_global_status_auroradb_delete_stmt_duration{service_name="$service"}[$interval])/ (sum(rate(mysql_global_status_commands_total{service_name="$service",command=~"delete|delete_multi"}[$interval])) without(command)))',
        refId='F',
        interval='$interval',
        intervalFactor=1,
        legendFormat='DELETE Latency',
      )
  ),
  gridPos={
    "h": 9,
    "w": 12,
    "x": 12,
    "y": 8,
   },
  style=null,
)//24 graph
.addPanel(
  graphPanel.new(
    'Amazon Aurora Special Command Counters',//title
    description='Amazon Aurora MySQL allows a number of commands which are not available in standard MySQL. This graph shows usage of such commands.  Regular “unit_test” calls can be seen in default Amazon Aurora install,  the rest will depend on your workload.

    * `show_volume_status`: The number of executions per second of the command SHOW VOLUME STATUS. The SHOW VOLUME STATUS query returns two server status variables, Disks and Nodes. These variables represent the total number of logical blocks of data and storage nodes, respectively, for the DB cluster volume.

    * `awslambda`: The number of AWS Lambda calls per second. AWS Lambda is an event-drive, server-less computing platform provided by AWS. It is a compute service that run codes in response to an event. You can run any kind of code from Aurora invoking Lambda from a stored procedure or a trigger.

    * `alter_system`: The number of executions per second of the special query ALTER SYSTEM, that is a special query to simulate an instance crash, a disk failure, a disk congestion or a replica failure. It’s a useful query for testing the system.',
    fill=1,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    paceLength=10,
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_rightSide=false,
    legend_show=true,
    legend_sortDesc=true,
    legend_sort='avg',
    editable=true,
    min=0,
    formatY1='ops',
    aliasColors={
        "DDL Latency": "#962d82",
        "DDL Load": "#962d82",
        "DELETE Latency": "#e5ac0e",
        "DELETE load": "#eab839",
        "INSERT Latency": "#0a437c",
        "INSERT load": "#0a437c",
        "SELECT Latency": "#508642",
        "SELECT load ": "#629e51",
        "UPDATE load": "#ea6460",
        "Write Transaction Commit Load": "#bf1b00"
      },
  )
  .addSeriesOverride(
   {
     "alias": "Key Blocks Not Flushed",
     "fill": 0
   }
  )
  .addTarget(
      prometheus.target(
        'rate(mysql_global_status_commands_total{service_name="$service",command=~"awslambda|alter_system|unit_test|show_volume_status"}[$interval])',
        refId='A',
        interval='$interval',
        intervalFactor=1,
        legendFormat='{{command}}',
      )
  ),
  gridPos={
      "h": 7,
       "w": 12,
       "x": 0,
       "y": 17,
   },
  style=null,
)//25 graph
.addPanel(
  graphPanel.new(
    'Amazon Aurora Problems',//title
    description='This graph shows different kinds of Internal Amazon Aurora MySQL Problems which general should be zero in normal operation.

    Anything non-zero is worth examining in greater depth.',
    fill=1,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    paceLength=10,
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_rightSide=false,
    legend_show=true,
    legend_sortDesc=true,
    legend_sort='avg',
    editable=true,
    min=0,
    formatY1='ops',
    aliasColors={
        "DDL Latency": "#962d82",
        "DDL Load": "#962d82",
        "DELETE Latency": "#e5ac0e",
        "DELETE load": "#eab839",
        "INSERT Latency": "#0a437c",
        "INSERT load": "#0a437c",
        "Missing History on Replica Incidents": "#e0752d",
        "Reserved Mem Exceeded Incidents": "#bf1b00",
        "SELECT Latency": "#508642",
        "SELECT load ": "#629e51",
        "Thread Deadlocks": "#ea6460",
        "UPDATE load": "#ea6460",
        "Write Transaction Commit Load": "#bf1b00"
      },
  )
  .addSeriesOverride(
      {
         "alias": "Key Blocks Not Flushed",
         "fill": 0
       }
  )
  .addTarget(
      prometheus.target(
        'rate(mysql_global_status_auroradb_thread_deadlocks{service_name="$service"}[$interval])',
        refId='A',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Thread Deadlocks',
      )
  )
  .addTarget(
      prometheus.target(
        'rate(mysql_global_status_aurora_missing_history_on_replica_incidents{service_name="$service"}[$interval])',
        refId='B',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Missing History on Replica Incidents',
      )
  )
  .addTarget(
      prometheus.target(
        'rate(mysql_global_status_aurora_reserved_mem_exceeded_incidents{service_name="$service"}[$interval])',
        refId='C',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Reserved Mem Exceeded Incidents',
      )
  ),
  gridPos={
      "h": 7,
       "w": 12,
       "x": 12,
       "y": 17,
   },
  style=null,
)//26 graph
