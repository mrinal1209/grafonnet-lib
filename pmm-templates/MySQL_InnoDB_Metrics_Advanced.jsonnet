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
  'MySQL InnoDB Metrics Advanced',
  time_from='now-12h',
  editable=false,
  refresh= "1m",
  graphTooltip='shared_crosshair',
  schemaVersion=18,
  version=4,
  tags=['Percona','MySQL'],
  iteration=1552404459950,
  uid="ibkrwGHmz",
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
      graphPanel.new(
        'Change Buffer Performance',//title
        description="The Change Buffer Performance graph shows the activity on the InnoDB change buffer.  The InnoDB change buffer records updates to non-unique secondary keys when the destination page is not in the buffer pool.  The updates are applied when the page is loaded in the buffer pool, prior to its use by a query.  Merge ratio is the number of insert buffer changes done per page, the higher the ratio the better is the efficiency of the change buffer.\n\nNote: If you do not see any metric, try running: ``SET GLOBAL innodb_monitor_enable=all;`` in the MySQL client.",
        fill=6,
        linewidth=1,
        decimals=2,
        datasource='Prometheus',
        lines=false,
        points=true,
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
        min=0,
      )
      .addSeriesOverride({
          "alias": "Ibuf Merge Ratio",
          "yaxis": 2
        })
      .addTarget(
          prometheus.target(
            'rate(mysql_info_schema_innodb_metrics_change_buffer_ibuf_merges_insert_total{service_name="$service"}[$interval]) or irate(mysql_info_schema_innodb_metrics_change_buffer_ibuf_merges_insert_total{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Ibuf Insert',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_info_schema_innodb_metrics_change_buffer_ibuf_merges_delete_total{service_name="$service"}[$interval]) or irate(mysql_info_schema_innodb_metrics_change_buffer_ibuf_merges_delete_total{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Ibuf Delete',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_info_schema_innodb_metrics_change_buffer_ibuf_merges_delete_mark_total{service_name="$service"}[$interval]) or irate(mysql_info_schema_innodb_metrics_change_buffer_ibuf_merges_delete_mark_total{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Ibuf Delete Mark',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_info_schema_innodb_metrics_change_buffer_ibuf_merges_total{service_name="$service"}[$interval]) or irate(mysql_info_schema_innodb_metrics_change_buffer_ibuf_merges_total{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Ibuf Merges',
          )
      )
      .addTarget(
          prometheus.target(
            '(rate(mysql_info_schema_innodb_metrics_change_buffer_ibuf_merges_insert_total{service_name="$service"}[$interval])+rate(mysql_info_schema_innodb_metrics_change_buffer_ibuf_merges_delete_total{service_name="$service"}[$interval])+rate(mysql_info_schema_innodb_metrics_change_buffer_ibuf_merges_delete_mark_total{service_name="$service"}[$interval]))/rate(mysql_info_schema_innodb_metrics_change_buffer_ibuf_merges_total{service_name="$service"}[$interval]) or (irate(mysql_info_schema_innodb_metrics_change_buffer_ibuf_merges_insert_total{service_name="$service"}[5m])+irate(mysql_info_schema_innodb_metrics_change_buffer_ibuf_merges_delete_total{service_name="$service"}[5m])+irate(mysql_info_schema_innodb_metrics_change_buffer_ibuf_merges_delete_mark_total{service_name="$service"}[5m]))/irate(mysql_info_schema_innodb_metrics_change_buffer_ibuf_merges_total{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Ibuf Merge Ratio',
          )
      ),
      gridPos={
        "h": 7,
         "w": 12,
         "x": 0,
         "y": 0
      },style=null
)//43 graph
.addPanel(
      graphPanel.new(
        'InnoDB Log Buffer Performance',//title
        description="The InnoDB Log Buffer Performance graph shows the efficiency of the InnoDB log buffer.  The InnoDB log buffer size is defined by the innodb_log_buffer_size parameter and illustrated on the graph by the Size metric.  Used is the amount of the buffer space that is used.  If Used is too high and gets close to Size, additional log writes will be required.\n\nNote: If you do not see any metric, try running: ``SET GLOBAL innodb_monitor_enable=all;`` in the MySQL client.",
        fill=2,
        linewidth=2,
        decimals=2,
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
        minY1=0,
        formatY1='bytes',
      )
      .addTarget(
          prometheus.target(
            'mysql_info_schema_innodb_metrics_recovery_log_lsn_current{service_name="$service"}*0 + on (instance) mysql_global_variables_innodb_log_buffer_size{service_name="$service"}',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Size',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'mysql_info_schema_innodb_metrics_recovery_log_lsn_current{service_name="$service"} - mysql_info_schema_innodb_metrics_recovery_log_lsn_last_flush{service_name="$service"}',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Used',
          )
      ),
      gridPos={
        "h": 7,
         "w": 12,
         "x": 12,
         "y": 0
      },style=null
)//44 graph
.addPanel(
      graphPanel.new(
        'InnoDB Page Splits',//title
        description="The InnoDB Page Splits graph shows the InnoDB page maintenance activity related to splitting and merging pages.  When an InnoDB page, other than the top most leaf page, has too much data to accept a row update or a row insert, it has to be split in two.  Similarly, if an InnoDB page, after a row update or delete operation, ends up being less than half full, an attempt is made to merge the page with a neighbor page. If the resulting page size is larger than the InnoDB page size, the operation fails.  If your workload causes a large number of page splits, try lowering the innodb_fill_factor variable (5.7+).\n\nNote: If you do not see any metric, try running: ``SET GLOBAL innodb_monitor_enable=all;`` in the MySQL client.",
        fill=2,
        linewidth=2,
        decimals=0,
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
        legend_hideZero=true,
        legend_hideEmpty=true,
        legend_current=true,
        editable=true,
        steppedLine=true,
        min=0,
        formatY2='percent',
        labelY1='Pages',
        labelY2='Successes  /  Attempts',
      )
      .addSeriesOverride({
          "alias": "Page Merge Successes / Page Merge Attempts",
          "yaxis": 2
        })
      .addTarget(
          prometheus.target(
            'rate(mysql_info_schema_innodb_metrics_index_index_page_merge_attempts_total{service_name="$service"}[$interval]) or irate(mysql_info_schema_innodb_metrics_index_index_page_merge_attempts_total{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Index Page Merge Attempts',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_info_schema_innodb_metrics_index_index_page_merge_successful_total{service_name="$service"}[$interval]) or irate(mysql_info_schema_innodb_metrics_index_index_page_merge_successful_total{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Index Page Merge Successful',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_info_schema_innodb_metrics_index_index_page_splits_total{service_name="$service"}[$interval]) or irate(mysql_info_schema_innodb_metrics_index_index_page_splits_total{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Index Page Splits',
          )
      )
      .addTarget(
          prometheus.target(
            '(rate(mysql_info_schema_innodb_metrics_index_index_page_merge_successful_total{service_name="$service"}[$interval]) or irate(mysql_info_schema_innodb_metrics_index_index_page_merge_successful_total{service_name="$service"}[5m])) / (rate(mysql_info_schema_innodb_metrics_index_index_page_merge_attempts_total{service_name="$service"}[$interval]) or irate(mysql_info_schema_innodb_metrics_index_index_page_merge_attempts_total{service_name="$service"}[5m])) * 100',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Page Merge Successes / Page Merge Attempts',
          )
      ),
      gridPos={
       "h": 7,
        "w": 12,
        "x": 0,
        "y": 7
      },style=null
)//58 graph
.addPanel(
      graphPanel.new(
        'InnoDB Page Reorgs',//title
        description="The InnoDB Page Reorgs graph shows information about the page reorganization operations.  When a page receives an  update or an insert that affect the offset of other rows in the page, a reorganization is needed.  If the reorganization process finds out there is not enough room in the page, the page will be split. Page reorganization can only fail for compressed pages.\n\nNote: If you do not see any metric, try running: ``SET GLOBAL innodb_monitor_enable=all;`` in the MySQL client.",
        fill=2,
        linewidth=2,
        decimals=0,
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
        legend_hideZero=true,
        legend_hideEmpty=true,
        legend_current=true,
        editable=true,
        steppedLine=true,
        min=0,
        maxY2='100',
        formatY2='percent',
      )
      .addSeriesOverride({
          "alias": "Reorg Successes / Reorg Attempts",
          "yaxis": 2
        })
      .addSeriesOverride({
          "alias": "Reorg Attempts / Reorg Successes",
          "yaxis": 2
        })
      .addTarget(
          prometheus.target(
            'rate(mysql_info_schema_innodb_metrics_index_index_page_reorg_attempts_total{service_name="$service"}[$interval]) or irate(mysql_info_schema_innodb_metrics_index_index_page_reorg_attempts_total{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Index Page Reorg Attempts',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_info_schema_innodb_metrics_index_index_page_reorg_successful_total{service_name="$service"}[$interval]) or irate(mysql_info_schema_innodb_metrics_index_index_page_reorg_successful_total{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Index Page Reorg Successful',
          )
      )
      .addTarget(
          prometheus.target(
            '(rate(mysql_info_schema_innodb_metrics_index_index_page_reorg_successful_total{service_name="$service"}[$interval]) or irate(mysql_info_schema_innodb_metrics_index_index_page_reorg_successful_total{service_name="$service"}[5m])) / (rate(mysql_info_schema_innodb_metrics_index_index_page_reorg_attempts_total{service_name="$service"}[$interval]) or irate(mysql_info_schema_innodb_metrics_index_index_page_reorg_attempts_total{service_name="$service"}[5m])) * 100',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Reorg Successes / Reorg Attempts',
          )
      ),
      gridPos={
       "h": 7,
        "w": 12,
        "x": 12,
        "y": 7
      },style=null
)//59 graph
.addPanel(
      graphPanel.new(
        'InnoDB Purge Performance',//title
        description="The InnoDB Purge Performance graph shows metrics about the page purging process.  The purge process removed the undo entries from the history list and cleanup the pages of the old versions of modified rows and effectively remove deleted rows.\n\nNote: If you do not see any metric, try running: ``SET GLOBAL innodb_monitor_enable=all;`` in the MySQL client.",
        fill=2,
        linewidth=2,
        decimals=2,
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
        minY1=0,
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_info_schema_innodb_metrics_purge_purge_upd_exist_or_extern_records_total{service_name="$service"}[$interval]) or irate(mysql_info_schema_innodb_metrics_purge_purge_upd_exist_or_extern_records_total{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Updates Purged',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_info_schema_innodb_metrics_purge_purge_del_mark_records_total{service_name="$service"}[$interval]) or irate(mysql_info_schema_innodb_metrics_purge_purge_del_mark_records_total{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Deletes Purged',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_info_schema_innodb_metrics_purge_purge_undo_log_pages_total{service_name="$service"}[$interval]) or irate(mysql_info_schema_innodb_metrics_purge_purge_undo_log_pages_total{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Pages Purged',
          )
      ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 0,
        "y": 14
      },style=null
)//45 graph
.addPanel(
      graphPanel.new(
        'InnoDB Locking',//title
        description="The InnoDB Locking graph shows the row level lock activity inside InnoDB. \n\nNote: If you do not see any metric, try running: ``SET GLOBAL innodb_monitor_enable=all;`` in the MySQL client.",
        fill=2,
        linewidth=2,
        decimals=2,
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
        minY1=0,
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_info_schema_innodb_metrics_lock_lock_rec_lock_created_total{service_name="$service"}[$interval]) or irate(mysql_info_schema_innodb_metrics_lock_lock_rec_lock_created_total{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Locks Created',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_info_schema_innodb_metrics_lock_lock_rec_lock_removed_total{service_name="$service"}[$interval]) or irate(mysql_info_schema_innodb_metrics_lock_lock_rec_lock_removed_total{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Locks Removed',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_info_schema_innodb_metrics_lock_lock_rec_lock_requests_total{service_name="$service"}[$interval]) or irate(mysql_info_schema_innodb_metrics_lock_lock_rec_lock_requests_total{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Locks Requested',
          )
      ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 12,
        "y": 14
      },style=null
)//48 graph
.addPanel(
      graphPanel.new(
        'InnoDB Main Thread Utilization',//title
        description="The InnoDB Main Thread Utilization graph shows the portion of time the InnoDB main thread spent at various task.\n\nNote: If you do not see any metric, try running: ``SET GLOBAL innodb_monitor_enable=all;`` in the MySQL client.",
        fill=2,
        linewidth=2,
        decimals=2,
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
        minY1=0,
        formatY1='percentunit',
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_info_schema_innodb_metrics_server_innodb_log_flush_usec_total{service_name="$service"}[$interval])/1000000 or irate(mysql_info_schema_innodb_metrics_server_innodb_log_flush_usec_total{service_name="$service"}[5m])/1000000',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Log Flushing',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_info_schema_innodb_metrics_server_innodb_ibuf_merge_usec_total{service_name="$service"}[$interval])/1000000 or irate(mysql_info_schema_innodb_metrics_server_innodb_ibuf_merge_usec_total{service_name="$service"}[5m])/1000000',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Insert Buffer Merging',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_info_schema_innodb_metrics_server_innodb_checkpoint_usec_total{service_name="$service"}[$interval])/1000000 or irate(mysql_info_schema_innodb_metrics_server_innodb_checkpoint_usec_total{service_name="$service"}[5m])/1000000',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Checkpointing',
          )
      ),
      gridPos={
       "h": 7,
        "w": 12,
        "x": 0,
        "y": 21
      },style=null
)//51 graph
.addPanel(
      graphPanel.new(
        'InnoDB Transactions Information',//title
        description="The InnoDB Transactions Information graph shows details about the recent transactions.  Transaction IDs Assigned represents the total number of transactions initiated by InnoDB.  RW Transaction Commits are the number of transactions not read-only. Insert-Update Transactions Commits are transactions on the Undo entries.  Non Locking RO Transaction Commits are transactions commit from select statement in auto-commit mode or transactions explicitly started with \"start transaction read only\".\n\nNote: If you do not see any metric, try running: ``SET GLOBAL innodb_monitor_enable=all;`` in the MySQL client.",
        fill=2,
        linewidth=2,
        decimals=2,
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
        minY1=0,
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_info_schema_innodb_metrics_transaction_trx_rw_commits_total{service_name="$service"}[$interval]) or irate(mysql_info_schema_innodb_metrics_transaction_trx_rw_commits_total{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='RW Transacton Commits',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_info_schema_innodb_metrics_transaction_trx_rollbacks_total{service_name="$service"}[$interval]) or irate(mysql_info_schema_innodb_metrics_transaction_trx_rollbacks_total{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Transaction Rollbacks',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_info_schema_innodb_metrics_transaction_trx_ro_commits_total{service_name="$service"}[$interval]) or irate(mysql_info_schema_innodb_metrics_transaction_trx_ro_commits_total{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='RO Transaction Commits',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_info_schema_innodb_metrics_transaction_trx_nl_ro_commits_total{service_name="$service"}[$interval]) or irate(mysql_info_schema_innodb_metrics_transaction_trx_nl_ro_commits_total{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Non Locking RO Transaction Commits',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_info_schema_innodb_metrics_transaction_trx_commits_insert_update_total{service_name="$service"}[$interval]) or irate(mysql_info_schema_innodb_metrics_transaction_trx_commits_insert_update_total{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Insert-Update Transaction Commits',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_innodb_max_trx_id{service_name="$service"}[$interval]) or irate(mysql_global_status_innodb_max_trx_id{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Transaction IDs Assigned',
          )
      ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 12,
        "y": 21
      },style=null
)//50 graph
.addPanel(
      graphPanel.new(
        'InnoDB Undo Space Usage',//title
        description="The InnoDB Undo Space Usage graph shows the amount of space used by the Undo segment.  If the amount of space grows too much, look for long running transactions holding read views opened in the InnoDB status.\n\nNote: If you do not see any metric, try running: ``SET GLOBAL innodb_monitor_enable=all;`` in the MySQL client.",
        fill=2,
        linewidth=2,
        decimals=2,
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
        minY1=0,
        formatY1='bytes',
      )
      .addTarget(
          prometheus.target(
            'mysql_info_schema_innodb_metrics_transaction_trx_rseg_current_size{service_name="$service"}*mysql_global_status_innodb_page_size{service_name="$service"}',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Innodb Undo Space Used',
            calculatedInterval='2m',
          )
      ),
      gridPos={
          "h": 7,
          "w": 12,
          "x": 0,
          "y": 28
      },style=null
)//49 graph
.addPanel(
      graphPanel.new(
        'InnoDB Activity',//title
        description="The InnoDB Acitivity graph shows a measure of the activity of the InnoDB threads. \n\nNote: If you do not see any metric, try running: ``SET GLOBAL innodb_monitor_enable=all;`` in the MySQL client.",
        fill=2,
        linewidth=2,
        decimals=2,
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
        minY1=0,
        aliasColors={
          "Innodb Activity": "#BA43A9"
        },
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_info_schema_innodb_metrics_server_innodb_activity_count_total{service_name="$service"}[$interval]) or irate(mysql_info_schema_innodb_metrics_server_innodb_activity_count_total{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='InnoDB Activity',
            calculatedInterval='2m',
          )
      ),
      gridPos={
          "h": 7,
          "w": 12,
          "x": 12,
          "y": 28
      },style=null
)//53 graph
.addPanel(
      graphPanel.new(
        'InnoDB Contention - OS Waits',//title
        description="The InnoDB Contention - OS Waits graph shows the number of time an OS wait operation was required while waiting to get the lock.  This happens once the spin rounds are exhausted.\n\nNote: If you do not see any metric, try running: ``SET GLOBAL innodb_monitor_enable=all;`` in the MySQL client.",
        fill=2,
        linewidth=2,
        decimals=2,
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
        minY1=0,
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_info_schema_innodb_metrics_server_innodb_rwlock_s_os_waits_total{service_name="$service"}[$interval]) or irate(mysql_info_schema_innodb_metrics_server_innodb_rwlock_s_os_waits_total{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='RW Locks S OS Waits',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_info_schema_innodb_metrics_server_innodb_rwlock_sx_os_waits_total{service_name="$service"}[$interval]) or irate(mysql_info_schema_innodb_metrics_server_innodb_rwlock_sx_os_waits_total{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='RW Locks SX OS Waits',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_info_schema_innodb_metrics_server_innodb_rwlock_x_os_waits_total{service_name="$service"}[$interval]) or irate(mysql_info_schema_innodb_metrics_server_innodb_rwlock_x_os_waits_total{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='RW Locks X OS Waits',
          )
      ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 0,
        "y": 35
      },style=null
)//55 graph
.addPanel(
      graphPanel.new(
        'InnoDB Contention - Spin Rounds',//title
        description="The InnoDB Contention - Spin Rounds  graph shows the number of spin rounds executed in order to get a lock.  A spin round is a fast retry to get the lock in a loop.\n\nNote: If you do not see any metric, try running: ``SET GLOBAL innodb_monitor_enable=all;`` in the MySQL client.",
        fill=2,
        linewidth=2,
        decimals=2,
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
        minY1=0,
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_info_schema_innodb_metrics_server_innodb_rwlock_s_spin_rounds_total{service_name="$service"}[$interval]) or irate(mysql_info_schema_innodb_metrics_server_innodb_rwlock_s_spin_rounds_total{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='RW Locks S Spin Rounds',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_info_schema_innodb_metrics_server_innodb_rwlock_sx_spin_rounds_total{service_name="$service"}[$interval]) or irate(mysql_info_schema_innodb_metrics_server_innodb_rwlock_sx_spin_rounds_total{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='RW Locks SX Spin Rounds',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_info_schema_innodb_metrics_server_innodb_rwlock_x_spin_rounds_total{service_name="$service"}[$interval]) or irate(mysql_info_schema_innodb_metrics_server_innodb_rwlock_x_spin_rounds_total{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='RW Locks X Spin Rounds',
          )
      ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 12,
        "y": 35
      },style=null
)//54 graph
.addPanel(
      graphPanel.new(
        'InnoDB Group Commit Batch Size',//title
        description="The InnoDB Group Commit Batch Size graph shows how many bytes were written to the InnoDB log files per attempt to write.  If many threads are committing at the same time, one of them will write the log entries of all the waiting threads and flush the file.  Such process reduces the number of disk operations needed and enlarge the batch size.\n\nNote: If you do not see any metric, try running: ``SET GLOBAL innodb_monitor_enable=all;`` in the MySQL client.",
        fill=1,
        linewidth=2,
        decimals=2,
        datasource='Prometheus',
        points=true,
        lines=false,
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
        minY1=0,
        aliasColors={
          "Avg Row Lock Wait Time": "#BF1B00"
        },
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_info_schema_innodb_metrics_transaction_trx_rw_commits_total{service_name="$service"}[$interval])/rate(mysql_global_status_innodb_log_writes{service_name="$service"}[$interval]) or irate(mysql_info_schema_innodb_metrics_transaction_trx_rw_commits_total{service_name="$service"}[5m])/irate(mysql_global_status_innodb_log_writes{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Group Commit Batch Size',
            calculatedInterval='2m',
          )
      ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 0,
        "y": 42
      },style=null
)//47 graph
.addPanel(
      graphPanel.new(
        'InnoDB Purge Throttling',//title
        description="The InnoDB Purge Throttling graph shows the evolution of the purge lag and the max purge lag currently set.  Under heavy write load, the purge operation may start to lag behind and when the max purge lag is reached, a delay, proportional to the value defined by innodb_max_purge_lag_delay (in microseconds) is added to all update, insert and delete statements.  This helps prevents flushing stalls.\n\nNote: If you do not see any metric, try running: ``SET GLOBAL innodb_monitor_enable=all;`` in the MySQL client.",
        fill=2,
        linewidth=2,
        decimals=2,
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
        minY1=0,
        formatY1='µs',
      )
      .addTarget(
          prometheus.target(
            'mysql_info_schema_innodb_metrics_purge_purge_dml_delay_usec{service_name="$service"}',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Current Purge Delay',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'mysql_global_variables_innodb_max_purge_lag_delay{service_name="$service"}',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Max Purge Delay',
          )
      ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 12,
        "y": 42
      },style=null
)//52 graph
.addPanel(
      graphPanel.new(
        'InnoDB AHI Usage',//title
        description="The InnoDB AHI Usage graph shows the search operations on the InnoDB adaptive hash index and its efficiency.  The adaptive hash index is a search hash designed to speed access to InnoDB pages in memory.  If the Hit Ratio is small, the working data set is larger than the buffer pool, the AHI should likely be disabled.\n\nNote: If you do not see any metric, try running: ``SET GLOBAL innodb_monitor_enable=all;`` in the MySQL client.",
        fill=2,
        linewidth=2,
        decimals=2,
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
        formatY2='percentunit',
      )
      .addSeriesOverride({
          "alias": "AHI - Hit Ratio",
          "yaxis": 2
        })
      .addTarget(
          prometheus.target(
            'rate(mysql_info_schema_innodb_metrics_adaptive_hash_index_adaptive_hash_searches_btree_total{service_name="$service"}[$interval])+
            rate(mysql_info_schema_innodb_metrics_adaptive_hash_index_adaptive_hash_searches_total{service_name="$service"}[$interval]) or
            irate(mysql_info_schema_innodb_metrics_adaptive_hash_index_adaptive_hash_searches_btree_total{service_name="$service"}[5m])+
            irate(mysql_info_schema_innodb_metrics_adaptive_hash_index_adaptive_hash_searches_total{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='AHI - Total Searches',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_info_schema_innodb_metrics_adaptive_hash_index_adaptive_hash_searches_total{service_name="$service"}[$interval]) or\nirate(mysql_info_schema_innodb_metrics_adaptive_hash_index_adaptive_hash_searches_total{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='AHI - Misses',
          )
      )
      .addTarget(
          prometheus.target(
            '1 - (rate(mysql_info_schema_innodb_metrics_adaptive_hash_index_adaptive_hash_searches_total{service_name="$service"}[$interval]))/
            (rate(mysql_info_schema_innodb_metrics_adaptive_hash_index_adaptive_hash_searches_total{service_name="$service"}[$interval])+
            rate(mysql_info_schema_innodb_metrics_adaptive_hash_index_adaptive_hash_searches_btree_total{service_name="$service"}[$interval])) or
            1 - (irate(mysql_info_schema_innodb_metrics_adaptive_hash_index_adaptive_hash_searches_total{service_name="$service"}[5m]))/
            (irate(mysql_info_schema_innodb_metrics_adaptive_hash_index_adaptive_hash_searches_total{service_name="$service"}[5m])+
            irate(mysql_info_schema_innodb_metrics_adaptive_hash_index_adaptive_hash_searches_btree_total{service_name="$service"}[5m]))',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='AHI - Hit Ratio',
          )
      ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 0,
        "y": 49
      },style=null
)//57 graph
.addPanel(
      graphPanel.new(
        'InnoDB AHI Maintenance',//title
        description="The InnoDB AHI Maintenance graph shows the maintenance operation of the InnoDB adaptive hash index.  The adaptive hash index is a search hash to speed access to InnoDB pages in memory. A constant high number of rows/pages added and removed can be an indication of an ineffective AHI.\n\nNote: If you do not see any metric, try running: ``SET GLOBAL innodb_monitor_enable=all;`` in the MySQL client.",
        fill=2,
        linewidth=2,
        decimals=2,
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
        minY1=0,
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_info_schema_innodb_metrics_adaptive_hash_index_adaptive_hash_pages_added_total{service_name="$service"}[$interval]) or irate(mysql_info_schema_innodb_metrics_adaptive_hash_index_adaptive_hash_pages_added_total{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='AHI - Pages Added',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_info_schema_innodb_metrics_adaptive_hash_index_adaptive_hash_pages_removed_total{service_name="$service"}[$interval]) or irate(mysql_info_schema_innodb_metrics_adaptive_hash_index_adaptive_hash_pages_removed_total{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='AHI - Pages Removed',
          )
      )
      .addTarget(
          prometheus.target(
            'rate( mysql_info_schema_innodb_metrics_adaptive_hash_index_adaptive_hash_rows_added_total{service_name="$service"}[$interval]) or irate( mysql_info_schema_innodb_metrics_adaptive_hash_index_adaptive_hash_rows_added_total{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='AHI - Rows Added',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_info_schema_innodb_metrics_adaptive_hash_index_adaptive_hash_rows_removed_total{service_name="$service"}[$interval]) or irate(mysql_info_schema_innodb_metrics_adaptive_hash_index_adaptive_hash_rows_removed_total{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='AHI - Rows Removed',
          )
      ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 12,
        "y": 49
      },style=null
)//56 graph
.addPanel(
      graphPanel.new(
        'InnoDB Online DDL',//title
        description="The InnoDB Online DDL graph shows the state of the online DDL (alter table) operations in InnoDB.  The progress metric is estimate of the percentage of the rows processed by the online DDL.\n\nNote: Currently available only on a MariaDB server.",
        fill=2,
        linewidth=2,
        decimals=0,
        datasource='Prometheus',
        pointradius=5,
        paceLength=10,
        legend_values=true,
        legend_min=false,
        legend_max=false,
        legend_avg=false,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sort='avg',
        legend_sortDesc=true,
        legend_current=true,
        editable=true,
        min=0,
        formatY2='percent',
        maxY2='100',
      )
      .addSeriesOverride({
          "alias": "% Progress",
          "yaxis": 2
        })
      .addTarget(
          prometheus.target(
            'mysql_global_status_innodb_onlineddl_pct_progress{service_name="$service"}/100',
            interval='$interval',
            step=5,
            intervalFactor=1,
            legendFormat='% Progress',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_innodb_onlineddl_rowlog_pct_used{service_name="$service"}[$interval]) or irate(mysql_global_status_innodb_onlineddl_rowlog_pct_used{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Row Log % Used',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_innodb_onlineddl_rowlog_rows{service_name="$service"}[$interval]) or irate(mysql_global_status_innodb_onlineddl_rowlog_rows{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Row Log Rows',
            calculatedInterval='2m',
          )
      ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 0,
        "y": 56
      },style=null
)//60 graph
.addPanel(
      graphPanel.new(
        'InnoDB Defragmentation',//title
        description="The InnoDB Defragmentation graph shows the status information related to the InnoDB online defragmentation feature of MariaDB for the optimize table command.  To enable this feature, the variable innodb-defragment must be set to 1 in the configuration file.\n\nNote: Currently available only on a MariaDB server.",
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
            'rate(mysql_global_status_innodb_defragment_count{service_name="$service"}[$interval]) or irate(mysql_global_status_innodb_defragment_count{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Count',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_innodb_defragment_compression_failures{service_name="$service"}[$interval]) or irate(mysql_global_status_innodb_defragment_compression_failures{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Re-Compression Failures',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_innodb_defragment_failures{service_name="$service"}[$interval]) or irate(mysql_global_status_innodb_defragment_failures{service_name="$service"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Failures',
            calculatedInterval='2m',
          )
      ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 12,
        "y": 56
      },style=null
)//61 graph
