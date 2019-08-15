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
  'MySQL MyRocks Metrics',
  time_from='now-12h',
  editable=false,
  refresh= "1m",
  graphTooltip='shared_crosshair',
  schemaVersion=18,
  version=3,
  tags=['Percona','MySQL'],
  iteration=1552405413941,
  uid="G1z9wGNmk",
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
  'label_values(mysql_global_variables_rocksdb_block_cache_size, node_name)',
  label='Host',
  refresh='load',
  allFormat='glob',
  sort=1,
  multi=false,
  multiFormat='regex values',
  skipUrlSync=false,
  definition='label_values(mysql_global_variables_rocksdb_block_cache_size, node_name)',
  includeAll=false,
  tagsQuery='',
  tagValuesQuery='',
  ),
)
.addTemplate(
  template.new(
  'service',
  'Prometheus',
  'label_values(mysql_global_variables_rocksdb_block_cache_size{node_name=~"$host"}, service_name)',
  label='Service',
  refresh='load',
  sort=0,
  multi=false,
  skipUrlSync=false,
  definition='label_values(mysql_global_variables_rocksdb_block_cache_size{node_name=~"$host"}, service_name)',
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
        'MyRocks  Cache',//title
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
        legend_sort='avg',
        legend_sortDesc=true,
        editable=true,
        height='250px',
        value_type='cumulative',
        min=0,
      )
      .addSeriesOverride({
          "alias": "RocksDB Cache",
          "fill": 0
        })
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_block_cache_hit{service_name="$service"}[$interval]) or irate(mysql_global_status_rocksdb_block_cache_hit{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='Hit',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_block_cache_miss{service_name="$service"}[$interval]) or  irate(mysql_global_status_rocksdb_block_cache_miss{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='Miss',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_block_cache_add{service_name="$service"}[$interval]) or irate(mysql_global_status_rocksdb_block_cache_add{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='Added',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_block_cache_add_failures{service_name="$service"}[$interval]) or irate(mysql_global_status_rocksdb_block_cache_add_failures{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='Added Failures',
            calculatedInterval='2m',
          )
      ),
      gridPos={
        "h": 7,
         "w": 12,
         "x": 0,
         "y": 0
      },style=null
)//1 graph
.addPanel(
      graphPanel.new(
        'MyRocks Cache Data Bytes R/W',//title
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
        legend_sort='avg',
        legend_sortDesc=true,
        legend_hideEmpty=true,
        legend_hideZero=true,
        editable=true,
        minY1=0,
        formatY1='bytes',
      )
      .addSeriesOverride({
          "alias": "System Memory",
          "fill": 0,
          "stack": false
        })
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_block_cache_bytes_read{service_name="$service"}[$interval])  or irate(mysql_global_status_rocksdb_block_cache_bytes_read{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='Reads',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_block_cache_bytes_write{service_name="$service"}[$interval]) or irate(mysql_global_status_rocksdb_block_cache_bytes_write{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='Writes',
          )
      ),
      gridPos={
        "h": 7,
         "w": 12,
         "x": 12,
         "y": 0
      },style=null
)//7 graph
.addPanel(
      graphPanel.new(
        'MyRocks Cache Index Hit Rate',//title
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
        legend_sort='avg',
        legend_sortDesc=true,
        editable=true,
        height='250px',
        value_type='cumulative',
        min=0,
      )
      .addSeriesOverride({
          "alias": "RocksDB Cache Index",
          "fill": 0
        })
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_block_cache_index_hit{service_name="$service"}[$interval])  or irate(mysql_global_status_rocksdb_block_cache_index_hit{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='Hit',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_block_cache_index_miss{service_name="$service"}[$interval]) or irate(mysql_global_status_rocksdb_block_cache_index_miss{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='Miss',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_block_cache_index_add{service_name="$service"}[$interval]) or irate(mysql_global_status_rocksdb_block_cache_index_add{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='Added',
            calculatedInterval='2m',
          )
      ),
      gridPos={
        "h": 7,
         "w": 12,
         "x": 0,
         "y": 7
      },style=null
)//3 graph
.addPanel(
      graphPanel.new(
        'MyRocks Cache Index',//title
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
        legend_sort='avg',
        legend_sortDesc=true,
        editable=true,
        height='250px',
        value_type='cumulative',
        min=0,
        formatY1='bytes',
      )
      .addSeriesOverride({
          "alias": "MyRocks Cache Index Bytes",
          "fill": 0
        })
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_block_cache_index_bytes_insert{service_name="$service"}[$interval]) or irate(mysql_global_status_rocksdb_block_cache_index_bytes_insert{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='Inserted',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_block_cache_index_bytes_evict{service_name="$service"}[$interval]) or irate(mysql_global_status_rocksdb_block_cache_index_bytes_evict{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='Evicted',
            calculatedInterval='2m',
          )
      ),
      gridPos={
        "h": 7,
         "w": 12,
         "x": 12,
         "y": 7
      },style=null
)//4 graph
.addPanel(
      graphPanel.new(
        'MyRocks Cache Filter Hit Rate',//title
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
        legend_sort='avg',
        legend_sortDesc=true,
        editable=true,
        height='250px',
        value_type='cumulative',
        min=0,
      )
      .addSeriesOverride({
          "alias": "MyRocks Cache Filter",
          "fill": 0
        })
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_block_cache_filter_hit{service_name="$service"}[$interval]) or irate(mysql_global_status_rocksdb_block_cache_filter_hit{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='Hit',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_block_cache_filter_miss{service_name="$service"}[$interval]) or irate(mysql_global_status_rocksdb_block_cache_filter_miss{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='Miss',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_block_cache_filter_add{service_name="$service"}[$interval]) or irate(mysql_global_status_rocksdb_block_cache_filter_add{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='Added',
            calculatedInterval='2m',
          )
      ),
      gridPos={
       "h": 7,
       "w": 12,
       "x": 0,
       "y": 14
      },style=null
)//5 graph
.addPanel(
      graphPanel.new(
        'MyRocks Cache Filter',//title
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
        legend_sort='avg',
        legend_sortDesc=true,
        editable=true,
        height='250px',
        value_type='cumulative',
        min=0,
      )
      .addSeriesOverride({
          "alias": "MyRocks Cache Filter Bytes",
          "fill": 0
        })
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_block_cache_filter_bytes_insert{service_name="$service"}[$interval]) or irate(mysql_global_status_rocksdb_block_cache_filter_bytes_insert{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='Inserted',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_block_cache_filter_bytes_evict{service_name="$service"}[$interval]) or irate(mysql_global_status_rocksdb_block_cache_filter_bytes_evict{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='Evicted',
            calculatedInterval='2m',
          )
      ),
      gridPos={
       "h": 7,
       "w": 12,
       "x": 12,
       "y": 14
      },style=null
)//6 graph
.addPanel(
      graphPanel.new(
        'MyRocks Cache Data Bytes Inserted',//title
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
        legend_sort='avg',
        legend_sortDesc=true,
        legend_hideZero=true,
        legend_hideEmpty=true,
        editable=true,
        stack=true,
        minY1=0,
        formatY1='bytes',
      )
      .addSeriesOverride({
          "alias": "System Memory",
          "fill": 0,
          "stack": false
        })
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_block_cache_data_bytes_insert{service_name="$service"}[$interval]) or irate(mysql_global_status_rocksdb_block_cache_data_bytes_insert{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='Bytes',
          )
      ),
      gridPos={
       "h": 7,
       "w": 12,
       "x": 0,
       "y": 21
      },style=null
)//8 graph
.addPanel(
      graphPanel.new(
        'MyRocks Bloom Filter',//title
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
        legend_sort='avg',
        legend_sortDesc=true,
        editable=true,
        stack=true,
        minY1=0,
        formatY1='bytes',
      )
      .addSeriesOverride({
          "alias": "System Memory",
          "fill": 0,
          "stack": false
        })
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_bloom_filter_useful{service_name="$service"}[$interval]) or irate(mysql_global_status_rocksdb_bloom_filter_useful{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='Useful',
          )
      ),
      gridPos={
       "h": 7,
       "w": 12,
       "x": 12,
       "y": 21
      },style=null
)//9 graph
.addPanel(
      graphPanel.new(
        'MyRocks Memtable',//title
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
        legend_sort='avg',
        legend_sortDesc=true,
        editable=true,
        height='250px',
        value_type='cumulative',
        min=0,
        formatY1='ops',
      )
      .addSeriesOverride({
          "alias": "MyRocks Memtable",
          "fill": 0
        })
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_memtable_hit{service_name="$service"}[$interval]) or irate(mysql_global_status_rocksdb_memtable_hit{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='Hit',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_memtable_miss{service_name="$service"}[$interval]) or irate(mysql_global_status_rocksdb_memtable_miss{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='Miss',
            calculatedInterval='2m',
          )
      ),
      gridPos={
       "h": 7,
       "w": 12,
       "x": 0,
       "y": 28
      },style=null
)//10 graph
.addPanel(
      graphPanel.new(
        'Memtable Size',//title
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
        minY1='0',
        formatY1='bytes',
        decimalsY1=2,
      )
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_global_status_rocksdb_memtable_total[$interval]) or\nmax_over_time(mysql_global_status_rocksdb_memtable_total[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Total',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_global_status_rocksdb_memtable_unflushed[$interval]) or\nmax_over_time(mysql_global_status_rocksdb_memtable_unflushed[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Unflushed',
          )
      ),
      gridPos={
       "h": 7,
       "w": 12,
       "x": 12,
       "y": 28
      },style=null
)//23 graph
.addPanel(
      graphPanel.new(
        'MyRocks Number Of Keys',//title
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
      )
      .addSeriesOverride({
          "alias": "MyRocks Number of Keys",
          "fill": 0
        })
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_number_keys_read{service_name="$service"}[$interval]) or irate(mysql_global_status_rocksdb_number_keys_read{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='Read',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_number_keys_written{service_name="$service"}[$interval]) or irate(mysql_global_status_rocksdb_number_keys_written{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='Write',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_number_keys_updated{service_name="$service"}[$interval]) or irate(mysql_global_status_rocksdb_number_keys_updated{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='Updated',
            calculatedInterval='2m',
          )
      ),
      gridPos={
       "h": 7,
       "w": 12,
       "x": 0,
       "y": 35
      },style=null
)//12 graph
.addPanel(
      graphPanel.new(
        'MyRocks Cache L0/L1',//title
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
        height='250px',
        value_type='cumulative',
        min=0,
      )
      .addSeriesOverride({
          "alias": "MyRocks Hit L0/l1",
          "fill": 0
        })
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_get_hit_l0{service_name="$service"}[$interval]) or irate(mysql_global_status_rocksdb_get_hit_l0{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='L0',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_get_hit_l1{service_name="$service"}[$interval]) or irate(mysql_global_status_rocksdb_get_hit_l1{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='L1',
            calculatedInterval='2m',
          )
      ),
      gridPos={
       "h": 7,
       "w": 12,
       "x": 12,
       "y": 35
      },style=null
)//11 graph
.addPanel(
      graphPanel.new(
        'MyRocks Number of DB ops',//title
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
        legend_sort='avg',
        legend_sortDesc=true,
        editable=true,
        height='250px',
        value_type='cumulative',
        min=0,
      )
      .addSeriesOverride({
          "alias": "MyRocks Number of DB ops",
          "fill": 0
        })
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_number_db_seek{service_name="$service"}[$interval]) or irate(mysql_global_status_rocksdb_number_db_seek{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='Seek',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_number_db_seek_found{service_name="$service"}[$interval]) or irate(mysql_global_status_rocksdb_number_db_seek_found{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='Seek Found',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_number_db_next{service_name="$service"}[$interval]) or irate(mysql_global_status_rocksdb_number_db_next{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='Next',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_number_db_next_found{service_name="$service"}[$interval]) or irate(mysql_global_status_rocksdb_number_db_next_found{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='Next Found',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_number_db_prev{service_name="$service"}[$interval]) or irate(mysql_global_status_rocksdb_number_db_prev{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='Prev',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_number_db_prev_found{service_name="$service"}[$interval]) or irate(mysql_global_status_rocksdb_number_db_prev_found{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='Prev Found',
            calculatedInterval='2m',
          )
      ),
      gridPos={
       "h": 7,
       "w": 12,
       "x": 0,
       "y": 42
      },style=null
)//14 graph
.addPanel(
      graphPanel.new(
        'MyRocks R/W',//title
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
        height='250px',
        value_type='cumulative',
        minY2=0,
        labelY1='(- write / + read)',
      )
      .addSeriesOverride({
          "alias": "MyRocks R/W",
          "fill": 0
        })
      .addSeriesOverride({
          "alias": "Write",
          "transform": "negative-Y"
        })
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_bytes_read{service_name="$service"}[$interval]) or irate(mysql_global_status_rocksdb_bytes_read{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='Read',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_bytes_written{service_name="$service"}[$interval]) or irate(mysql_global_status_rocksdb_bytes_written{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='Write',
            calculatedInterval='2m',
          )
      ),
      gridPos={
       "h": 7,
       "w": 12,
       "x": 12,
       "y": 42
      },style=null
)//13 graph
.addPanel(
      graphPanel.new(
        'MyRocks Bytes Read by Iterations',//title
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
        legend_sort='avg',
        legend_sortDesc=true,
        legend_hideZero=true,
        legend_hideEmpty=true,
        editable=true,
        stack=true,
        minY1=0,
        formatY1='bytes',
      )
      .addSeriesOverride({
          "alias": "System Memory",
          "fill": 0,
          "stack": false
        })
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_iter_bytes_read{service_name="$service"}[$interval]) or irate(mysql_global_status_rocksdb_iter_bytes_read{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='Reads',
          )
      ),
      gridPos={
       "h": 7,
        "w": 12,
        "x": 0,
        "y": 49
      },style=null
)//15 graph
.addPanel(
      graphPanel.new(
        'MyRocks Write ops',//title
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
        legend_sort='avg',
        legend_sortDesc=true,
        editable=true,
        height='250px',
        value_type='cumulative',
        min=0,
      )
      .addSeriesOverride({
          "alias": "MyRocks Write ops",
          "fill": 0
        })
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_write_self{service_name="$service"}[$interval]) or irate(mysql_global_status_rocksdb_write_self{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='Self',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_write_other{service_name="$service"}[$interval]) or irate(mysql_global_status_rocksdb_write_other{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='Other',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_write_timeout{service_name="$service"}[$interval]) or irate(mysql_global_status_rocksdb_write_timeout{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='Timeout',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_write_wal{service_name="$service"}[$interval]) or irate(mysql_global_status_rocksdb_write_wal{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='WAL',
            calculatedInterval='2m',
          )
      ),
      gridPos={
       "h": 7,
       "w": 12,
       "x": 12,
       "y": 49
      },style=null
)//19 graph
.addPanel(
      graphPanel.new(
        'MyRocks WAL',//title
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
        legend_sort='avg',
        legend_sortDesc=true,
        editable=true,
        height='250px',
        value_type='cumulative',
        min=0,
      )
      .addSeriesOverride({
          "alias": "MyRocks WAL",
          "fill": 0
        })
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_wal_synced{service_name="$service"}[$interval]) or irate(mysql_global_status_rocksdb_wal_synced{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='Syncs',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_wal_bytes{service_name="$service"}[$interval])  or irate(mysql_global_status_rocksdb_wal_bytes{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='Bytes',
            calculatedInterval='2m',
          )
      ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 0,
        "y": 56
      },style=null
)//17 graph
.addPanel(
      graphPanel.new(
        'MyRocks Number Reseeks in Iterations',//title
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
        legend_sort='avg',
        legend_sortDesc=true,
        legend_hideZero=true,
        legend_hideEmpty=true,
        editable=true,
        stack=true,
        minY1=0,
        formatY1='none',
      )
      .addSeriesOverride({
          "alias": "System Memory",
          "fill": 0,
          "stack": false
        })
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_number_reseeks_iteration{service_name="$service"}[$interval]) or irate(mysql_global_status_rocksdb_number_reseeks_iteration{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='Reseeks',
          )
      ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 12,
        "y": 56
      },style=null
)//16 graph
.addPanel(
      graphPanel.new(
        'RocksDB Row Operations',//title
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
        legend_sort='avg',
        legend_sortDesc=true,
        editable=true,
        minY1='0',
        formatY1='ops',
        decimalsY1=0,
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_rows_inserted{service_name="$service"}[$interval]) or \nirate(mysql_global_status_rocksdb_rows_inserted{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Rows Inserted',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_rows_updated{service_name="$service"}[$interval]) or \nirate(mysql_global_status_rocksdb_rows_updated{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Rows Updated',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_rows_deleted{service_name="$service"}[$interval]) or \nirate(mysql_global_status_rocksdb_rows_deleted{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Rows Deleted',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_rows_read{service_name="$service"}[$interval]) or \nirate(mysql_global_status_rocksdb_rows_read{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Rows Read',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_rows_expired{service_name="$service"}[$interval]) or \nirate(mysql_global_status_rocksdb_rows_expired{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Rows Expired',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_system_rows_deleted{service_name="$service"}[$interval]) or \nirate(mysql_global_status_rocksdb_system_rows_deleted{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='System Rows Deleted',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_system_rows_inserted{service_name="$service"}[$interval]) or \nirate(mysql_global_status_rocksdb_system_rows_inserted{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='System Rows Inserted',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_system_rows_read{service_name="$service"}[$interval]) or \nirate(mysql_global_status_rocksdb_system_rows_read{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='System Rows Read',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_system_rows_updated{service_name="$service"}[$interval]) or \nirate(mysql_global_status_rocksdb_system_rows_updated{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='System Rows Updated',
          )
      ),
      gridPos={
       "h": 7,
       "w": 12,
       "x": 0,
       "y": 63
      },style=null
)//21 graph
.addPanel(
      graphPanel.new(
        'MyRocks File Operations',//title
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
        legend_sort='avg',
        legend_sortDesc=true,
        editable=true,
        height='250px',
        value_type='cumulative',
        min=0,
      )
      .addSeriesOverride({
          "alias": "File Operations",
          "fill": 0
        })
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_no_file_opens{service_name="$service"}[$interval]) or irate(mysql_global_status_rocksdb_no_file_opens{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='Open',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_no_file_closes{service_name="$service"}[$interval]) or irate(mysql_global_status_rocksdb_no_file_closes{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='Closes',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_no_file_errors{service_name="$service"}[$interval]) or irate(mysql_global_status_rocksdb_no_file_errors{service_name="$service"}[5m])',
            interval='$interval',
            step=10,
            intervalFactor=1,
            legendFormat='Errors',
            calculatedInterval='2m',
          )
      ),
      gridPos={
       "h": 7,
       "w": 12,
       "x": 12,
       "y": 63
      },style=null
)//18 graph
.addPanel(
      graphPanel.new(
        'RocksDB Stalls',//title
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
        minY1='0',
        decimalsY1=0,
      )
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_global_status_rocksdb_stall_total_stops[$interval]) or\nmax_over_time(mysql_global_status_rocksdb_stall_total_stops[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Total Stops',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_global_status_rocksdb_stall_total_slowdowns[$interval]) or \nmax_over_time(mysql_global_status_rocksdb_stall_total_slowdowns[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Total Slowdowns',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_global_status_rocksdb_stall_micros[$interval]) or \nmax_over_time(mysql_global_status_rocksdb_stall_micros[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Micros',
          )
      ),
      gridPos={
       "h": 7,
       "w": 12,
       "x": 0,
       "y": 70
      },style=null
)//25 graph
.addPanel(
      graphPanel.new(
        'RocksDB Stops/Slowdowns',//title
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
        legend_sort='avg',
        legend_sortDesc=true,
        editable=true,
        minY1='0',
        formatY1='ops',
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_stall_l0_file_count_limit_slowdowns[$interval]) or\nirate(mysql_global_status_rocksdb_stall_l0_file_count_limit_slowdowns[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='L0 File count limit slowdowns',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_stall_l0_file_count_limit_stops[$interval]) or\nirate(mysql_global_status_rocksdb_stall_l0_file_count_limit_stops[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='L0 File count limit stops',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_stall_locked_l0_file_count_limit_slowdowns[$interval]) or\nirate(mysql_global_status_rocksdb_stall_locked_l0_file_count_limit_slowdowns[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Locked L0 File count limit slowdowns',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_stall_locked_l0_file_count_limit_stops[$interval]) or\nirate(mysql_global_status_rocksdb_stall_locked_l0_file_count_limit_stops[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Locked L0 File count limit stops',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_stall_memtable_limit_slowdowns[$interval]) or\nirate(mysql_global_status_rocksdb_stall_memtable_limit_slowdowns[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Memtable limit slowdowns',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_rocksdb_stall_memtable_limit_stops[$interval]) or\nirate(mysql_global_status_rocksdb_stall_memtable_limit_stops[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Memtable limit stops',
          )
      ),
      gridPos={
       "h": 7,
       "w": 12,
       "x": 12,
       "y": 70
      },style=null
)//27 graph
