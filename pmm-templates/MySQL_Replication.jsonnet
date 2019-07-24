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
  'MySQL Replication',
  time_from='now-12h',
  editable=false,
  refresh= "1m",
  graphTooltip='shared_crosshair',
  schemaVersion=18,
  version=3,
  tags=['Percona','MySQL'],
  iteration=1553784660353,
  uid="_9zrwMHmk",
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
  'replication_set',
  'Prometheus',
  'label_values(mysql_up, replication_set)',
  label='Replication Set',
  refresh='load',
  sort=0,
  multi=false,
  skipUrlSync=false,
  definition='label_values(mysql_up, replication_set)',
  includeAll=false,
  ),
)
.addTemplate(
  template.new(
  'service',
  'Prometheus',
  'label_values(mysql_up{replication_set=~"$replication_set"}, service_name)',
  label='Service',
  refresh='load',
  sort=0,
  multi=false,
  skipUrlSync=false,
  definition='label_values(mysql_up{replication_set=~"$replication_set"}, service_name)',
  includeAll=false,
  ),
)
.addTemplate(
  template.new(
  'host',
  'Prometheus',
  'label_values(mysql_binlog_files{service_name="$service"}, node_name)',
  allFormat='glob',
  label='Host',
  refresh='load',
  hide=2,
  sort=1,
  multi=false,
  multiFormat='regex values',
  skipUrlSync=false,
  definition='label_values(mysql_binlog_files{service_name="$service"}, node_name)',
  includeAll=false,
  ),
)
.addPanel(
  singlestat.new(
    'Host',//title
    format='none',
    datasource='Prometheus',
    thresholds='',
    tableColumn='node_name',
  )
  .addTarget(
    prometheus.target(
      'mysql_up{service_name=~"$service"}',
      intervalFactor = 1,
      format='table',
      interval='',
      legendFormat='{{node_name}}',
    )
  ),
  gridPos = {
        "h": 3,
        "w": 8,
        "x": 0,
        "y": 0,
  },
  style=null,
)//41 singlestat
.addPanel(
  singlestat.new(
    'IO Thread Running',//title
    colorBackground=true,
    decimals=0,
    colors=[
        "rgba(161, 18, 18, 0.9)",
        "rgba(237, 129, 40, 0.89)",
        "rgba(36, 112, 33, 0.97)"
      ],
    description='Displays whether the IO Thread is in the running state or not. Applies only to a Slave host. The IO Thread connects to the Master host and reads binary log events, and then copies them locally to a file called the relay log.\n\nPossible values:\n\n**Yes** – IO Thread is running and is connected to a Master\n\n**No** – The IO Thread is not running because it is not yet started, or because an error occured while connecting to the Master\n\n**Connecting** – The IO Thread is running but is not fully connected to a Master\n\n**No value** – The host is not configured to be a Slave.\n\nIO Thread Running is one of the parameters returned by **SHOW SLAVE STATUS** command.\n\nSee also:',
    format='short',
    height='125px',
    datasource='Prometheus',
    interval='$interval',
    thresholds='0.5,1',
    prefixFontSize='80%',
    valueName='current',
    links=[
        {
          "targetBlank": true,
          "title": "Replication",
          "type": "absolute",
          "url": "https://dev.mysql.com/doc/refman/5.7/en/replication.html"
        },
        {
          "targetBlank": true,
          "title": "SHOW SLAVE STATUS Syntax",
          "type": "absolute",
          "url": "https://dev.mysql.com/doc/refman/5.7/en/show-slave-status.html"
        },
        {
          "targetBlank": true,
          "title": "IO Thread states",
          "type": "absolute",
          "url": "https://dev.mysql.com/doc/refman/5.7/en/slave-io-thread-states.html"
        }
      ],
    valueMaps=[
          {
            "op": "=",
            "text": "Yes",
            "value": "1"
          },
          {
            "op": "=",
            "text": "No",
            "value": "0"
          }
        ],
  )
  .addTarget(
    prometheus.target(
      'min(min_over_time(mysql_slave_status_slave_io_running{service_name="$service"}[$interval]) or min_over_time(mysql_slave_status_slave_io_running{service_name="$service"}[5m]))',
      intervalFactor = 1,
      interval='$interval',
      legendFormat='',
      calculatedInterval='10m',
      step=300,
    )
  ),
  gridPos = {
        "h": 3,
        "w": 4,
        "x": 8,
        "y": 0,
  },
  style=null,
)//26 singlestat
.addPanel(
  singlestat.new(
    'SQL Thread Running',//title
    colorBackground=true,
    decimals=0,
    colors=[
        "rgba(161, 18, 18, 0.9)",
        "rgba(237, 129, 40, 0.89)",
        "rgba(36, 112, 33, 0.97)"
      ],
    description='Displays whether the SQL Thread is in the running state or not. Applies only to a Slave host. The SQL Thread reads the events from the local relay log file and applies them to the Slave host.  Depending on the format of the binary log it can read query statements (STATEMENT format) and re-executes them, or by reading row changes (ROW format) and applying only the changes.\n\nPossibile values:\n\n**Yes** – The SQL Thread is running and is applying events from the realy log to the local Slave host\n\n**No** – The SQL Thread is not running because it is not yet started, or because of an error\n\nSee also:',
    format='short',
    height='125px',
    datasource='Prometheus',
    interval='$interval',
    thresholds='0.5,1',
    prefixFontSize='80%',
    valueName='current',
    links=[
        {
          "targetBlank": true,
          "title": "Replication",
          "type": "absolute",
          "url": "https://dev.mysql.com/doc/refman/5.7/en/replication.html"
        },
        {
          "targetBlank": true,
          "title": "SHOW SLAVE STATUS Syntax",
          "type": "absolute",
          "url": "https://dev.mysql.com/doc/refman/5.7/en/show-slave-status.html"
        },
        {
          "targetBlank": true,
          "title": "SQL Thread states",
          "type": "absolute",
          "url": "https://dev.mysql.com/doc/refman/5.7/en/slave-sql-thread-states.html"
        }
      ],
    valueMaps=[
          {
            "op": "=",
            "text": "Yes",
            "value": "1"
          },
          {
            "op": "=",
            "text": "No",
            "value": "0"
          }
        ],
  )
  .addTarget(
    prometheus.target(
      'min(min_over_time(mysql_slave_status_slave_sql_running{service_name="$service"}[$interval]) or min_over_time(mysql_slave_status_slave_sql_running{service_name="$service"}[5m]))',
      intervalFactor = 1,
      interval='$interval',
      legendFormat='',
      calculatedInterval='10m',
      step=300,
    )
  ),
  gridPos = {
        "h": 3,
        "w": 4,
        "x": 12,
        "y": 0,
  },
  style=null,
)//17 singlestat
.addPanel(
  singlestat.new(
    'Replication Error No',//title
    colorValue=true,
    decimals=0,
    colors=[
     "rgba(50, 172, 45, 0.97)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(245, 54, 54, 0.9)"
      ],
    description='Displays the number of the last error that the SQL Thread encountered which caused replication to stop.\n\nOne of the more common errors is \"Error: 1022 Duplicate Key Entry\". In such a case replication is attempting to update a row that already exists on the Slave. The SQL Thread will stop replication in order to avoid data corruption.\n\nSee also:',
    format='none',
    height='125px',
    datasource='Prometheus',
    interval='$interval',
    thresholds='0.5,1',
    prefixFontSize='80%',
    valueName='current',
    links=[
        {
          "targetBlank": true,
          "title": "List of error codes",
          "type": "absolute",
          "url": "https://dev.mysql.com/doc/refman/5.7/en/error-messages-server.html"
        }
      ],
    valueMaps=[
        {
          "op": "=",
          "text": "N/A",
          "value": "0"
        }
      ],
  )
  .addTarget(
    prometheus.target(
      'max(max_over_time(mysql_slave_status_last_errno{service_name="$service"}[$interval]) or max_over_time(mysql_slave_status_last_errno{service_name="$service"}[5m]))',
      intervalFactor = 1,
      interval='5m',
      legendFormat='',
      calculatedInterval='10m',
      step=300,
    )
  ),
  gridPos = {
        "h": 3,
        "w": 4,
        "x": 16,
        "y": 0,
  },
  style=null,
)//39 singlestat
.addPanel(
  singlestat.new(
    'Read Only',//title
    colors=[
     "rgba(50, 172, 45, 0.97)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(245, 54, 54, 0.9)"
      ],
      decimals=0,
    description='Displays whether the host is configured to be in Read Only mode or not.\n\nPossible values:\n\n**Yes** – the host blocks client updates except from users who have the SUPER or REPLICATION SLAVE privilege.This kind of configuration is typically used on Slave hosts in a replication environment to prevent client data modification causing inconsistencies and stopping the replication process.\n\n**No** – the host is not configured for Read Only mode, and will permit local client data modification operations (if the client has appropriate privileges to the database objects).',
    format='short',
    height='125px',
    datasource='Prometheus',
    interval='$interval',
    thresholds='0.5,1',
    prefixFontSize='80%',
    valueName='current',
    links=[
        {
          "targetBlank": true,
          "title": "Replication",
          "type": "absolute",
          "url": "https://dev.mysql.com/doc/refman/5.7/en/replication.html"
        }
      ],
    valueMaps=[
        {
          "op": "=",
          "text": "Yes",
          "value": "1"
        },
        {
          "op": "=",
          "text": "No",
          "value": "0"
        }
      ],
  )
  .addTarget(
    prometheus.target(
      'min(min_over_time(mysql_global_variables_read_only{service_name="$service"}[$interval]) or min_over_time(mysql_global_variables_read_only{service_name="$service"}[5m]))',
      intervalFactor = 1,
      interval='5m',
      legendFormat='',
      calculatedInterval='10m',
      step=300,
    )
  ),
  gridPos = {
        "h": 3,
        "w": 4,
        "x": 20,
        "y": 0,
  },
  style=null,
)//27 singlestat
.addPanel(
  graphPanel.new(
    'MySQL Replication Delay',//title
    description='Shows the number of seconds the Slave host is delayed in replication applying events compared to when the Master host applied them, denoted by the **Seconds_Behind_Master** value, and only applies to a Slave host. The most common reasons for Slaves to lag their Master are:\n\n* Network round trip time - High latency links will lead to non-zero replication lag values\n\n* Single threaded nature of replication channels - Master servers have the advantage of applying changes in parallel, whereas Slaves are only able to apply changes in serial, thus limiting their throughput.  In some cases Group Commit can help but is not always applicable.\n\n* High number of changed rows or computationally expensive SQL - Depending on the replication format (ROW vs STATEMENT), significant changes to the database through high volume of rows modified, or expensive CPU will all contribute to Slaves lagging behind their Master\n\nGenerally adding more CPU or Disk resources can alleviate replication lag issues, up to a point.\n\nIdeally a value of 0 is desired, but be aware that **Seconds_Behind_Master** is an integer value and thus rounding is a factor. If you desire greater precision, consider the Percona Toolkit tool pt-heartbeat, as this graph will automatically take into account this tool and then show you greater resolution.\n\nSee also:',
    fill=2,
    linewidth=2,
    decimals=0,
    datasource='Prometheus',
    paceLength=10,
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    legend_rightSide=true,
    editable=true,
    min=0,
    links=[
        {
          "targetBlank": true,
          "title": "SHOW SLAVE STATUS Syntax",
          "type": "absolute",
          "url": "https://dev.mysql.com/doc/refman/5.7/en/show-slave-status.html"
        },
        {
          "targetBlank": true,
          "title": "Improving replication performance",
          "type": "absolute",
          "url": "https://dev.mysql.com/doc/refman/5.7/en/replication-solutions-performance.html"
        },
        {
          "targetBlank": true,
          "title": "Replication Slave Options and Variables",
          "type": "absolute",
          "url": "https://dev.mysql.com/doc/refman/5.7/en/replication-options-slave.html"
        }
      ],
  )
  .addSeriesOverride(
    {
      "alias": "Lag",
      "color": "#E24D42"
    }
  )
  .addTarget(
      prometheus.target(
        'max_over_time(mysql_slave_status_seconds_behind_master{service_name="$service"}[$interval]) or max_over_time(mysql_slave_status_seconds_behind_master{service_name="$service"}[5m])',
        calculatedInterval='2m',
        interval='$interval',
        legendFormat='Lag',
        intervalFactor=1,
        step=300,
      )
  ),
  gridPos={
    "h": 7,
    "w": 24,
    "x": 0,
    "y": 3,
  },
  style=null,
)//16 graph
.addPanel(
  graphPanel.new(
    'Binlogs Size',//title
    description='Shows the overall size of the binary log files, which can exist on both Masters and Slaves. The binary log (also known as the binlog) contains events that describe database changes: CREATE TABLE, ALTER TABLE, updates, inserts, deletes and other statements or database changes. The binlog is the file that is read by Slaves via their IO Thread process in order to replicate database changes modification on the data and on the table structures. There can be more than one binlog file present depending on the binlog rotation policy adopted (for example using the configuration variables **max_binlog_size** and **expire_logs_days**).\n\nSee also:',
    fill=2,
    linewidth=2,
    datasource='Prometheus',
    paceLength=10,
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    editable=true,
    min=0,
    format='bytes',
    links=[
        {
          "targetBlank": true,
          "title": "The binary log",
          "type": "absolute",
          "url": "https://dev.mysql.com/doc/refman/5.7/en/binary-log.html"
        },
        {
          "targetBlank": true,
          "title": "Configuring replication",
          "type": "absolute",
          "url": "https://dev.mysql.com/doc/refman/5.7/en/replication-configuration.html"
        }
      ],
  )
  .addSeriesOverride(
    {
        "alias": "Size",
        "color": "#1F78C1"
      }
  )
  .addTarget(
      prometheus.target(
        'max_over_time(mysql_binlog_size_bytes{service_name="$service"}[$interval]) or max_over_time(mysql_binlog_size_bytes{service_name="$service"}[5m])',
        calculatedInterval='2m',
        interval='$interval',
        legendFormat='Size',
        intervalFactor=1,
        step=300,
      )
  ),
  gridPos={
    "h": 7,
     "w": 12,
     "x": 0,
     "y": 10,
  },
  style=null,
)//33 graph
.addPanel(
  graphPanel.new(
    'Binlog Data Written Hourly',//title
    description='Shows the amount of data written to the binlog files, grouped into hourly buckets. This graph can give you an idea of the amount of changes to your data.',
    fill=2,
    linewidth=2,
    decimals=2,
    bars=true,
    lines=false,
    datasource='Prometheus',
    paceLength=10,
    pointradius=5,
    legend_values=false,
    legend_min=false,
    legend_max=false,
    legend_avg=false,
    legend_alignAsTable=false,
    legend_show=false,
    editable=true,
    min=0,
    format='bytes',
    timeFrom='24h',
  )
  .addSeriesOverride(
    {
        "alias": "Size",
        "color": "#1F78C1"
      }
  )
  .addTarget(
      prometheus.target(
        'increase(mysql_binlog_size_bytes{service_name="$service"}[1h])',
        calculatedInterval='2m',
        interval='1h',
        legendFormat='Size',
        intervalFactor=1,
        step=3600,
      )
  ),
  gridPos={
    "h": 7,
     "w": 12,
     "x": 12,
     "y": 10,
  },
  style=null,
)//35 graph
.addPanel(
  graphPanel.new(
    'Binlogs Count',//title
    description='Shows the overall count of binary log files, which can exist on both Masters and Slaves. The binary log (also known as the binlog) contains events that describe database changes: CREATE TABLE, ALTER TABLE, updates, inserts, deletes and other statements or database changes. The binlog is the file that is read by Slaves via their IO Thread process in order to replicate database changes modification on the data and on the table structures. There can be more than one binlog file present depending on the binlog rotation policy adopted (for example using the configuration variables **max_binlog_size** and **expire_logs_days**).\n\nSee also:',
    fill=2,
    linewidth=2,
    decimals=0,
    datasource='Prometheus',
    paceLength=10,
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    editable=true,
    min=0,
    format='none',
    links=[
        {
          "targetBlank": true,
          "title": "The binary log",
          "type": "absolute",
          "url": "https://dev.mysql.com/doc/refman/5.7/en/binary-log.html"
        },
        {
          "targetBlank": true,
          "title": "Configuring replication",
          "type": "absolute",
          "url": "https://dev.mysql.com/doc/refman/5.7/en/replication-configuration.html"
        }
      ],
  )
  .addSeriesOverride(
      {
          "alias": "Count",
          "color": "#E0752D"
        }
  )
  .addTarget(
      prometheus.target(
        'max_over_time(mysql_binlog_files{service_name="$service"}[$interval]) or max_over_time(mysql_binlog_files{service_name="$service"}[5m])',
        calculatedInterval='2m',
        interval='$interval',
        legendFormat='Count',
        intervalFactor=1,
        step=300,
      )
  ),
  gridPos={
    "h": 7,
     "w": 12,
     "x": 0,
     "y": 17,
  },
  style=null,
)//34 graph
.addPanel(
  graphPanel.new(
    'Binlogs Created Hourly',//title
    description='Shows the number of binlog files created hourly. The number depends on the rotation policy adopted using the configuration variables **max_binlog_size** and **expire_logs_days**.',
    fill=2,
    linewidth=2,
    decimals=0,
    bars=true,
    lines=false,
    datasource='Prometheus',
    paceLength=10,
    pointradius=5,
    legend_values=false,
    legend_min=false,
    legend_max=false,
    legend_avg=false,
    legend_alignAsTable=false,
    legend_show=false,
    editable=true,
    min=0,
    format='none',
    decimalsY1=0,
    timeFrom='24h',
  )
  .addSeriesOverride(
      {
          "alias": "Count",
          "color": "#E0752D"
        }
  )
  .addTarget(
      prometheus.target(
        'increase(mysql_binlog_file_number{service_name="$service"}[1h])',
        calculatedInterval='2m',
        interval='1h',
        intervalFactor=1,
        legendFormat='Count',
        step=3600,
      )
  ),
  gridPos={
    "h": 7,
     "w": 12,
     "x": 12,
     "y": 17,
  },
  style=null,
)//36 graph
.addPanel(
  graphPanel.new(
    'Relay Log Space',//title
    description='Shows the overall size of the relay log files, and applies only to Slaves. The relay log consists of a set of numbered files containing the events to be executed on a Slave in order to replicate database changes.  As soon as the SQL Thread completes execution of all events in a relay log file, the relay log file is then deleted by MySQL.\n\nSee also:',
    fill=2,
    linewidth=2,
    datasource='Prometheus',
    paceLength=10,
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=true,
    editable=true,
    min=0,
    format='bytes',
    links=[
        {
          "targetBlank": true,
          "title": "The Slave Relay Log",
          "type": "absolute",
          "url": "https://dev.mysql.com/doc/refman/5.7/en/slave-logs-relaylog.html"
        }
      ],
  )
  .addSeriesOverride(
    {
       "alias": "Size",
       "color": "#BA43A9"
     }
  )
  .addTarget(
      prometheus.target(
        'max_over_time(mysql_slave_status_relay_log_space{service_name="$service"}[$interval]) or max_over_time(mysql_slave_status_relay_log_space{service_name="$service"}[5m])',
        calculatedInterval='2m',
        interval='$interval',
        intervalFactor=1,
        legendFormat='Size',
        step=300,
      )
  ),
  gridPos={
    "h": 7,
     "w": 12,
     "x": 0,
     "y": 24,
  },
  style=null,
)//37 graph
.addPanel(
  graphPanel.new(
    'Relay Log Written Hourly',//title
    description='Shows the amount of data written hourly to the relay log files.',
    fill=2,
    decimals=2,
    linewidth=2,
    bars=true,
    lines=false,
    datasource='Prometheus',
    paceLength=10,
    pointradius=5,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_show=false,
    editable=true,
    min=0,
    format='bytes',
    timeFrom='24h',
  )
  .addSeriesOverride(
    {
       "alias": "Size",
       "color": "#BA43A9"
     }
  )
  .addTarget(
      prometheus.target(
        'increase(mysql_slave_status_relay_log_space{service_name="$service"}[1h])',
        calculatedInterval='2m',
        interval='1h',
        intervalFactor=1,
        legendFormat='Size',
        step=3600,
      )
  ),
  gridPos={
    "h": 7,
     "w": 12,
     "x": 12,
     "y": 24,
  },
  style=null,
)//38 graph
