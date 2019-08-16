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
  'MySQL InnoDB Metrics',
  time_from='now-12h',
  editable=false,
  refresh= "1m",
  graphTooltip='shared_crosshair',
  schemaVersion=18,
  version=3,
  tags=['Percona','MySQL'],
  iteration=1558460916811,
  uid="giGgrTimz",
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
    'Home',
    ['Home'],
    type='link',
    url='/graph/d/Fxvd1timk/home-dashboard',
    keepTime=true,
    includeVars=true,
    asDropdown=false,
    icon='doc',
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
    'Compare',
    ['Compare'],
    type='link',
    url='/graph/d/KQdFKEGWz/mysql-services-compare',
    keepTime=true,
    includeVars=true,
    asDropdown=false,
    icon='bolt',
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
    'Services',
    ['Services'],
    keepTime=true,
    includeVars=false,
  )
)
.addLink(
  grafana.link.dashboards(
    'PMM',
    ['PMM'],
    keepTime=true,
    includeVars=false,
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
  allFormat='glob',
  sort=1,
  multi=false,
  multiFormat='regex values',
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
  multi=false,
  skipUrlSync=false,
  definition='label_values(mysql_up{node_name=~"$host"}, service_name)',
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
      title='Checkpoint',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 0,
    },
    style=null,
)//51 row
.addPanel(
      graphPanel.new(
        'InnoDB Checkpoint Age',//title
        description="**InnoDB Checkpoint Age**\n\nThe maximum checkpoint age is determined by the total length of all transaction log files (`innodb_log_file_size`).\n\nWhen the checkpoint age reaches the maximum checkpoint age, blocks are flushed syncronously. The rules of the thumb is to keep one hour of traffic in those logs and let the checkpointing perform its work as smooth as possible. If you don't do this, InnoDB will do synchronous flushing at the worst possible time, ie when you are busiest.",
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
        decimalsY1=2,
        format='bytes',
        aliasColors={
          "Max Checkpoint Age": "#BF1B00",
          "Uncheckpointed Bytes": "#E0752D"
        },
      )
      .addSeriesOverride({
          "alias": "Max Checkpoint Age",
          "color": "#BF1B00",
          "fill": 0
        })
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_global_status_innodb_checkpoint_age{service_name="$service"}[$interval]) or
            max_over_time(mysql_global_status_innodb_checkpoint_age{service_name="$service"}[5m]) or
            max_over_time(mysql_info_schema_innodb_metrics_recovery_log_lsn_checkpoint_age_total{service_name="$service"}[$interval]) or
            max_over_time(mysql_info_schema_innodb_metrics_recovery_log_lsn_checkpoint_age_total{service_name="$service"}[5m]) or
            max_over_time(mysql_info_schema_innodb_metrics_log_log_lsn_checkpoint_age{service_name="$service"}[$interval]) or
            max_over_time(mysql_info_schema_innodb_metrics_log_log_lsn_checkpoint_age{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Uncheckpointed Bytes',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_global_status_innodb_checkpoint_max_age{service_name="$service"}[$interval]) or
            max_over_time(mysql_global_status_innodb_checkpoint_max_age{service_name="$service"}[5m]) or
            max_over_time(mysql_info_schema_innodb_metrics_recovery_log_max_modified_age_async{service_name="$service"}[$interval]) or
            max_over_time(mysql_info_schema_innodb_metrics_recovery_log_max_modified_age_async{service_name="$service"}[5m]) or
            max_over_time(mysql_info_schema_innodb_metrics_log_log_max_modified_age_async{service_name="$service"}[$interval]) or
            max_over_time(mysql_info_schema_innodb_metrics_log_log_max_modified_age_async{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Max Checkpoint Age',
            calculatedInterval='2m',
          )
      ),
      gridPos={
         "h": 7,
         "w": 12,
         "x": 0,
         "y": 1
      },style=null
)//19 graph
.addPanel(
      graphPanel.new(
        'InnoDB Transactions',//title
        description="**Innodb Transactions** \n\nInnoDB is an MVCC storage engine, which means you can start a transaction and continue to see a consistent snapshot \neven as the data changes. This is implemented by keeping old versions of rows as they are modified.\n\nThe InnoDB History List is the undo logs which are used to store these modifications. They are a fundamental part of InnoDB\u2019s transactional architecture.\n\nIf history length is rising regularly, do not let open connections linger for a long period as this can affect the performance of InnoDB considerably. It is also a good idea to look for long running queries in PMM's Query Analytics.",
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
        legend_hideZero=true,
        editable=true,
        min=0,
        links=[
                {
                    "dashboard": "_PMM Query Analytics",
                    "dashUri": "db/_pmm-query-analytics",
                    "title": "Query Analytics",
                    "type": "dashboard",
                    "url": "/graph/d/7w6Q3PJmz/pmm-query-analytics"
                }
            ],
      )
      .addSeriesOverride({
          "alias": "InnoDB Transactions",
          "yaxis": 2
        })
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_innodb_max_trx_id{service_name="$service"}[$interval]) or irate(mysql_global_status_innodb_max_trx_id{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='InnoDB Transactions',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            '(max_over_time(mysql_global_status_innodb_history_list_length{service_name="$service"}[$interval]) or
            max_over_time(mysql_global_status_innodb_history_list_length{service_name="$service"}[5m])) or
            (max_over_time(mysql_info_schema_innodb_metrics_transaction_trx_rseg_history_len{service_name="$service"}[$interval]) or
            max_over_time(mysql_info_schema_innodb_metrics_transaction_trx_rseg_history_len{service_name="$service"}[5m]))',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='History Length',
            calculatedInterval='2m',
          )
      ),
      gridPos={
         "h": 7,
         "w": 12,
         "x": 12,
         "y": 1
      },style=null
)//20 graph
.addPanel(
    row.new(
      title='Row Operations',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 8,
    },
    style=null,
)//52 row
.addPanel(
      graphPanel.new(
        'InnoDB Row Operations',//title
        description="**InnoDB Row Operations**\n\nThis graph allows you to see which operations occur and the number of rows affected per operation. A graph like Queries Per Second will give you an idea of queries, but one query could effect millions of rows",
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
        legend_hideZero=true,
        editable=true,
        min=0,
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_innodb_row_ops_total{service_name="$service"}[$interval]) or irate(mysql_global_status_innodb_row_ops_total{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Rows {{ operation }}',
            calculatedInterval='2m',
          )
      ),
      gridPos={
       "h": 7,
       "w": 12,
       "x": 0,
       "y": 9
      },style=null
)//23 graph
.addPanel(
      graphPanel.new(
        'InnoDB Row Lock Time',//title
        description="**InnoDB Row Lock Time**\n\nWhen data is locked, then that means that another ***session can NOT update that data until the lock*** is released (which unlocks the data and allows other users to update that data). Locks are usually released by either a ROLLBACK or COMMIT SQL statement.\n\nInnoDB implements standard row-level locking where there are two types of locks, [shared (S) locks](https://dev.mysql.com/doc/refman/5.7/en/glossary.html#glos_shared_lock) and [exclusive (X) locks](https://dev.mysql.com/doc/refman/5.7/en/glossary.html#glos_exclusive_lock).\n\n* A [shared (S) lock](https://dev.mysql.com/doc/refman/5.7/en/glossary.html#glos_shared_lock) permits the transaction that holds the lock to read a row.\n* An [exclusive (X) lock](https://dev.mysql.com/doc/refman/5.7/en/glossary.html#glos_exclusive_lock) permits the transaction that holds the lock to update or delete a row.\n\n_Average Row Lock Wait Time_ is the row lock wait time divided by the number of row locks.\\\n_Row Lock Waits_ are how many times a transaction waited on a row lock per second.\\\n_Row Lock Wait Load_ is a rolling 5 minute average of Row Lock Waits.",
        fill=1,
        linewidth=2,
        decimals=2,
        lines=false,
        points=true,
        datasource='Prometheus',
        pointradius=1,
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
        steppedLine=true,
        min=0,
        formatY2='ms',
        aliasColors={
          "Avg Row Lock Wait Time": "#BF1B00"
        },
        links=[
          {
            "dashboard": "https://dev.mysql.com/doc/refman/5.7/en/innodb-locking.html",
            "targetBlank": true,
            "title": "InnoDB Locking",
            "type": "absolute",
            "url": "https://dev.mysql.com/doc/refman/5.7/en/innodb-locking.html"
          }
        ],
      )
      .addSeriesOverride({
          "alias": "Avg Row Lock Wait Time",
          "yaxis": 2
        })
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_innodb_row_lock_waits{service_name="$service"}[$interval]) or irate(mysql_global_status_innodb_row_lock_waits{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Row Lock Waits',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_innodb_row_lock_time{service_name="$service"}[$interval])/1000 or irate(mysql_global_status_innodb_row_lock_time{service_name="$service"}[5m])/1000',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Row Lock Wait Load',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_innodb_row_lock_time{service_name="$service"}[$interval])/rate(mysql_global_status_innodb_row_lock_waits{service_name="$service"}[$interval]) or irate(mysql_global_status_innodb_row_lock_time{service_name="$service"}[5m])/irate(mysql_global_status_innodb_row_lock_waits{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Avg Row Lock Wait Time',
          )
      ),
      gridPos={
       "h": 7,
       "w": 12,
       "x": 12,
       "y": 9
      },style=null
)//46 graph
.addPanel(
    row.new(
      title='I/O',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 16,
    },
    style=null,
)//53 row
.addPanel(
      graphPanel.new(
        'InnoDB I/O',//title
        description="**InnoDB I/O**\n\n_Data Writes_ - The total number of InnoDB data writes.\\\n_Data Reads_ - The total number of InnoDB data reads (OS file reads).\\\n_Log Writes_ - The number of physical writes to the InnoDB redo log file.\\\n_Data Fsyncs_ - The number of fsync() operations. The frequency of fsync() calls is influenced by the setting of the `innodb_flush_method` configuration option.",
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
            'rate(mysql_global_status_innodb_data_reads{service_name="$service"}[$interval]) or irate(mysql_global_status_innodb_data_reads{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Data Reads',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_innodb_data_writes{service_name="$service"}[$interval]) or irate(mysql_global_status_innodb_data_writes{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Data Writes',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_innodb_data_fsyncs{service_name="$service"}[$interval]) or irate(mysql_global_status_innodb_data_fsyncs{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Data Fsyncs',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_innodb_log_writes{service_name="$service"}[$interval]) or irate(mysql_global_status_innodb_log_writes{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Log Writes',
            calculatedInterval='2m',
          )
      ),
      gridPos={
         "h": 7,
         "w": 12,
         "x": 0,
         "y": 17
      },style=null
)//38 graph
.addPanel(
      graphPanel.new(
        'InnoDB Log File Usage Hourly',//title
        description="**InnoDB Log File Usage Hourly**\n\nAlong with the buffer pool size, `innodb_log_file_size` is the most important setting when we are working with InnoDB. This graph shows how much data was written to InnoDB's redo logs over each hour. When the InnoDB log files are full, InnoDB needs to flush the modified pages from memory to disk.\n\nThe rules of the thumb is to keep one hour of traffic in those logs and let the checkpointing perform its work as smooth as possible. If you don't do this, InnoDB will do synchronous flushing at the worst possible time, ie when you are busiest.\n\nThis graph can help guide you in setting the correct `innodb_log_file_size`.",
        fill=2,
        linewidth=2,
        decimals=2,
        bars=true,
        lines=false,
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
        timeFrom='24h',
        min=0,
        formatY1='bytes',
        logBase1Y=2,
        links=[
          {
            "targetBlank": true,
            "title": "How to calculate a good InnoDB log file size",
            "type": "absolute",
            "url": "https://www.percona.com/blog/2008/11/21/how-to-calculate-a-good-innodb-log-file-size/"
          },
          {
            "targetBlank": true,
            "title": "System Variables (innodb_log_file_size)",
            "type": "absolute",
            "url": "http://www.percona.com/doc/percona-server/5.5/scalability/innodb_io_55.html#innodb_log_file_size"
          }
        ],
      )
      .addSeriesOverride({
          "alias": "Total Size of InnoDB Log Files",
          "bars": false,
          "color": "#E24D42",
          "fill": 0,
          "lines": true
        })
      .addSeriesOverride({
          "alias": "Data Written",
          "color": "#E0752D"
        })
      .addTarget(
          prometheus.target(
            'increase(mysql_global_status_innodb_os_log_written{service_name="$service"}[1h])',
            interval='1h',
            step=3600,
            intervalFactor=1,
            legendFormat='Data Written',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'mysql_global_variables_innodb_log_files_in_group{service_name="$service"} * mysql_global_variables_innodb_log_file_size{service_name="$service"}',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Total Size of InnoDB Log Files',
            calculatedInterval='2m',
          )
      ),
      gridPos={
         "h": 7,
         "w": 12,
         "x": 12,
         "y": 17
      },style=null
)//37 graph
.addPanel(
      graphPanel.new(
        'Innodb Logging Performance',
        fill=2,
        linewidth=2,
        decimals=2,
        points=true,
        lines=false,
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
        min=0,
        formatY1='Bps',
        formatY2='s',
        logBase2Y=2,
        aliasColors={
          "Data Written to Logs": "#E24D42",
          "Time to Use Redo Log Space ": "#447EBC"
        },
      )
      .addSeriesOverride({
          "alias": "Time to Use Redo Log Space ",
          "yaxis": 2
        })
      .addSeriesOverride({
          "alias": "Time to Use In-Memory Log Buffer",
          "yaxis": 2
        })
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_innodb_os_log_written{service_name="$service"}[$interval]) or irate(mysql_global_status_innodb_os_log_written{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Data Written to Logs',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'avg by (service_name) (mysql_global_variables_innodb_log_files_in_group{service_name="$service"} * mysql_global_variables_innodb_log_file_size{service_name="$service"})/avg by (service_name) (rate(mysql_global_status_innodb_os_log_written{service_name="$service"}[$interval]) or irate(mysql_global_status_innodb_os_log_written{service_name="$service"}[5m]))',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Time to Use Redo Log Space ',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'avg by (service_name) (mysql_global_variables_innodb_log_buffer_size{service_name="$service"})/avg by (service_name) (rate(mysql_global_status_innodb_os_log_written{service_name="$service"}[$interval]) or irate(mysql_global_status_innodb_os_log_written{service_name="$service"}[5m]))',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Time to Use In-Memory Log Buffer',
          )
      ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 0,
        "y": 24
      },style=null
)//50 graph
.addPanel(
    row.new(
      title='Deadlocks and ICP',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 31,
    },
    style=null,
)//54 row
.addPanel(
      graphPanel.new(
        'InnoDB Deadlocks',//title
        description="**InnoDB Deadlocks**\n\nA deadlock in MySQL happens when two or more transactions mutually hold and request for locks, creating a cycle of dependencies. In a transaction system, deadlocks are a fact of life and not completely avoidable. InnoDB automatically detects transaction deadlocks, rollbacks a transaction immediately and returns an error.",
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
        min=0,
        links=[
          {
            "targetBlank": true,
            "title": "How to deal with MySQL deadlocks",
            "type": "absolute",
            "url": "https://www.percona.com/blog/2014/10/28/how-to-deal-with-mysql-deadlocks/"
          }
        ],
      )
      .addTarget(
          prometheus.target(
            '(rate(mysql_global_status_innodb_deadlocks{service_name="$service"}[$interval]) or rate(mysql_info_schema_innodb_metrics_lock_lock_deadlocks_total{service_name="$service"}[$interval])) or (irate(mysql_global_status_innodb_deadlocks{service_name="$service"}[5m]) or irate(mysql_info_schema_innodb_metrics_lock_lock_deadlocks_total{service_name="$service"}[5m]))',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Deadlocks',
            calculatedInterval='2m',
          )
      ),
      gridPos={
         "h": 7,
         "w": 12,
         "x": 0,
         "y": 32
      },style=null
)//47 graph
.addPanel(
      graphPanel.new(
        'Index Condition Pushdown (ICP)',//title
        description="Index Condition Pushdown (ICP) is an optimization for the case where MySQL retrieves rows from a table using an index. Without ICP, the storage engine traverses the index to locate rows in the base table and returns them to the MySQL server which evaluates the\u00a0WHERE condition for the rows. With ICP enabled, and if parts of the\u00a0WHERE\u00a0condition can be evaluated by using only columns from the index, the MySQL server pushes this part of the\u00a0WHERE\u00a0condition down to the storage engine. The storage engine then evaluates the pushed index condition by using the index entry and only if this is satisfied is the row read from the table. ICP can reduce the number of times the storage engine must access the base table and the number of times the MySQL server must access the storage engine.",
        fill=1,
        linewidth=1,
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
        legend_hideZero=true,
        legend_current=true,
        editable=true,
        minY1='0',
        links=[
          {
            "targetBlank": true,
            "title": "Index Condition Pushdown optimisation - MySQL 5.7 Manual",
            "type": "absolute",
            "url": "https://dev.mysql.com/doc/refman/5.7/en/index-condition-pushdown-optimization.html"
          },
          {
            "targetBlank": true,
            "title": "ICP counters and how to interpret them",
            "type": "absolute",
            "url": "https://www.percona.com/blog/2017/05/09/mariadb-handler_icp_-counters-what-they-are-and-how-to-use-them/"
          }
        ],
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_info_schema_innodb_metrics_icp_icp_attempts_total{service_name="$service"}[$interval])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Attempts',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_info_schema_innodb_metrics_icp_icp_match_total{service_name="$service"}[$interval])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Matches',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_info_schema_innodb_metrics_icp_icp_no_match_total{service_name="$service"}[$interval])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='No Matches',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_info_schema_innodb_metrics_icp_icp_out_of_range_total{service_name="$service"}[$interval])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Out of Range',
          )
      ),
      gridPos={
         "h": 7,
         "w": 12,
         "x": 12,
         "y": 32
      },style=null
)//48 graph
.addPanel(
    row.new(
      title='Buffer Pool',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 39,
    },
    style=null,
)//55 row
.addPanel(
      graphPanel.new(
        'InnoDB Buffer Pool Content',//title
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
            'max_over_time(mysql_global_status_innodb_buffer_pool_bytes_data{service_name="$service"}[$interval]) or\nmax_over_time(mysql_global_status_innodb_buffer_pool_bytes_data{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Data Total',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_global_status_innodb_buffer_pool_bytes_dirty{service_name="$service"}[$interval]) or\nmax_over_time(mysql_global_status_innodb_buffer_pool_bytes_dirty{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Data Dirty',
            calculatedInterval='2m',
          )
      ),
      gridPos={
         "h": 7,
         "w": 12,
         "x": 0,
         "y": 40,
      },style=null
)//42 graph
.addPanel(
      graphPanel.new(
        'InnoDB Buffer Pool Pages',//title
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
      )
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_global_status_buffer_pool_pages{service_name="$service", state=~"free|data|misc"}[$interval]) or\nmax_over_time(mysql_global_status_buffer_pool_pages{service_name="$service", state=~"free|data|misc"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='{{ state }}',
            calculatedInterval='2m',
          )
      ),
      gridPos={
         "h": 7,
         "w": 12,
         "x": 12,
         "y": 40,
      },style=null
)//3 graph
.addPanel(
    row.new(
      title='Buffer Pool I/O',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 47,
    },
    style=null,
)//56 row
.addPanel(
      graphPanel.new(
        'InnoDB Buffer Pool I/O',//title
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
            'rate(mysql_global_status_innodb_pages_created{service_name="$service"}[$interval]) or irate(mysql_global_status_innodb_pages_created{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Pages Created',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_innodb_pages_read{service_name="$service"}[$interval]) or irate(mysql_global_status_innodb_pages_read{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Pages Read',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_innodb_pages_written{service_name="$service"}[$interval]) or irate(mysql_global_status_innodb_pages_written{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Pages Written',
            calculatedInterval='2m',
          )
      ),
      gridPos={
         "h": 7,
         "w": 12,
         "x": 0,
         "y": 48,
      },style=null
)//21 graph
.addPanel(
      graphPanel.new(
        'InnoDB Buffer Pool Requests',//title
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
      .addSeriesOverride({
          "alias": "Disk Reads",
          "yaxis": 2
        })
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_innodb_buffer_pool_read_requests{service_name="$service"}[$interval]) or irate(mysql_global_status_innodb_buffer_pool_read_requests{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Read Requests',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_innodb_buffer_pool_write_requests{service_name="$service"}[$interval]) or irate(mysql_global_status_innodb_buffer_pool_write_requests{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Write Requests',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_innodb_buffer_pool_reads{service_name="$service"}[$interval]) or irate(mysql_global_status_innodb_buffer_pool_reads{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Disk Reads',
            calculatedInterval='2m',
          )
      ),
      gridPos={
         "h": 7,
         "w": 12,
         "x": 12,
         "y": 48,
      },style=null
)//41 graph
.addPanel(
      graphPanel.new(
        'Innodb Read-Ahead',//title
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
        aliasColors={
          "Paged Fetched by Random Read Ahead": "#6ED0E0",
          "Paged Fetched by Read Ahead but Never Accessed": "#EF843C",
          "Percent of IO Caused by Read Ahead": "#0A437C",
          "Read Ahead Waste Percent": "#BF1B00"
        },
      )
      .addSeriesOverride({
          "alias": "Read Ahead Waste Percent",
          "yaxis": 2
        })
      .addSeriesOverride({
          "alias": "Percent of IO Caused by Read Ahead",
          "yaxis": 2
        })
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_innodb_buffer_pool_read_ahead{service_name="$service"}[$interval]) or irate(mysql_global_status_innodb_buffer_pool_read_ahead{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Pages Fetched by Linear Read Ahead',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_innodb_buffer_pool_read_ahead_rnd{service_name="$service"}[$interval]) or irate(mysql_global_status_innodb_buffer_pool_read_ahead_rnd{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Paged Fetched by Random Read Ahead',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_innodb_buffer_pool_read_ahead_evicted{service_name="$service"}[$interval]) or irate(mysql_global_status_innodb_buffer_pool_read_ahead_evicted{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Paged Fetched by Read Ahead but Never Accessed',
            metric='go_gc_duration_seconds_count',
          )
      )
      .addTarget(
          prometheus.target(
            '(rate(mysql_global_status_innodb_buffer_pool_read_ahead_evicted{service_name="$service"}[$interval]) or irate(mysql_global_status_innodb_buffer_pool_read_ahead_evicted{service_name="$service"}[5m])) / ((rate(mysql_global_status_innodb_buffer_pool_read_ahead{service_name="$service"}[$interval]) or irate(mysql_global_status_innodb_buffer_pool_read_ahead{service_name="$service"}[5m])) + (rate(mysql_global_status_innodb_buffer_pool_read_ahead_rnd{service_name="$service"}[$interval]) or irate(mysql_global_status_innodb_buffer_pool_read_ahead_rnd{service_name="$service"}[5m])))',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Read Ahead Waste Percent',
          )
      )
      .addTarget(
          prometheus.target(
            '((rate(mysql_global_status_innodb_buffer_pool_read_ahead{service_name="$service"}[$interval]) or irate(mysql_global_status_innodb_buffer_pool_read_ahead{service_name="$service"}[5m]))+(rate(mysql_global_status_innodb_buffer_pool_read_ahead_rnd{service_name="$service"}[$interval]) or irate(mysql_global_status_innodb_buffer_pool_read_ahead_rnd{service_name="$service"}[5m])))/(rate(mysql_global_status_innodb_pages_read{service_name="$service"}[$interval]) or irate(mysql_global_status_innodb_pages_read{service_name="$service"}[5m])\n)',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Percent of IO Caused by Read Ahead',
          )
      ),
      gridPos={
       "h": 7,
       "w": 12,
       "x": 0,
       "y": 55
      },style=null
)//49 graph
.addPanel(
    row.new(
      title='Change/Insert Buffer',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 62,
    },
    style=null,
)//57 row
.addPanel(
      graphPanel.new(
        'InnoDB Change Buffer',//title
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
        min=0,
        formatY1='bytes',
        aliasColors={
          "Uncheckpointed Bytes": "#E0752D"
        },
      )
      .addTarget(
          prometheus.target(
            '(max_over_time(mysql_global_status_innodb_ibuf_segment_size{service_name="$service"}[$interval]) or
            max_over_time(mysql_global_status_innodb_ibuf_segment_size{service_name="$service"}[5m])) *
            (max_over_time(mysql_global_status_innodb_page_size{service_name="$service"}[$interval]) or
            max_over_time(mysql_global_status_innodb_page_size{service_name="$service"}[5m]))',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Allocated',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            '((max_over_time(mysql_global_status_innodb_ibuf_segment_size{service_name="$service"}[$interval]) or
            max_over_time(mysql_global_status_innodb_ibuf_segment_size{service_name="$service"}[5m])) -
            (max_over_time(mysql_global_status_innodb_ibuf_free_list{service_name="$service"}[$interval]) or
            max_over_time(mysql_global_status_innodb_ibuf_free_list{service_name="$service"}[5m]))) *
            (max_over_time(mysql_global_status_innodb_page_size{service_name="$service"}[$interval]) or
            max_over_time(mysql_global_status_innodb_page_size{service_name="$service"}[5m]))',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Used',
            calculatedInterval='2m',
          )
      ),
      gridPos={
       "h": 7,
       "w": 12,
       "x": 0,
       "y": 63
      },style=null
)//39 graph
.addPanel(
      graphPanel.new(
        'InnoDB Change Buffer Activity',//title
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
            'rate(mysql_global_status_innodb_ibuf_merges{service_name="$service"}[$interval]) or irate(mysql_global_status_innodb_ibuf_merges{service_name="$service"}[5m]) or rate(mysql_info_schema_innodb_metrics_change_buffer_ibuf_merges_total{service_name="$service"}[$interval]) or irate(mysql_info_schema_innodb_metrics_change_buffer_ibuf_merges_total{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Merges',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_innodb_ibuf_merged_inserts{service_name="$service"}[$interval]) or irate(mysql_global_status_innodb_ibuf_merged_inserts{service_name="$service"}[5m]) or rate(mysql_info_schema_innodb_metrics_change_buffer_ibuf_merges_insert_total{service_name="$service"}[$interval]) or irate(mysql_info_schema_innodb_metrics_change_buffer_ibuf_merges_insert_total{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Merged Inserts',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_innodb_ibuf_merged_deletes{service_name="$service"}[$interval]) or irate(mysql_global_status_innodb_ibuf_merged_deletes{service_name="$service"}[5m]) or rate(mysql_info_schema_innodb_metrics_change_buffer_ibuf_merges_delete_total{service_name="$service"}[$interval]) or irate(mysql_info_schema_innodb_metrics_change_buffer_ibuf_merges_delete_total{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Merged Deletes',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_innodb_ibuf_merged_delete_marks{service_name="$service"}[$interval]) or irate(mysql_global_status_innodb_ibuf_merged_delete_marks{service_name="$service"}[5m]) or rate(mysql_info_schema_innodb_metrics_change_buffer_ibuf_merges_delete_mark_total{service_name="$service"}[$interval]) or irate(mysql_info_schema_innodb_metrics_change_buffer_ibuf_merges_delete_mark_total{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Merged Delete Marks',
            calculatedInterval='2m',
          )
      ),
      gridPos={
       "h": 7,
       "w": 12,
       "x":12,
       "y": 63
      },style=null
)//40 graph
