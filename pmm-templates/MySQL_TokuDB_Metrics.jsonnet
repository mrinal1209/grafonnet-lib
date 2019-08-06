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

dashboard.new(
  'MySQL TokuDB Metrics',
  time_from='now-12h',
  editable=false,
  refresh= "1m",
  graphTooltip='shared_crosshair',
  schemaVersion=18,
  version=3,
  tags=['MySQL','Percona'],
  iteration=1552407257442,
  uid="7Xk9QMNmk",
  timepicker = timepicker.new(
      hidden=false,
      now=true,
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
  'label_values(mysql_global_variables_tokudb_cache_size, node_name)',
  label='Host',
  refresh='load',
  sort=1,
  allFormat='glob',
  multiFormat='glob',
  multi=false,
  skipUrlSync=false,
  definition='label_values(mysql_global_variables_tokudb_cache_size, node_name)',
  includeAll=false,
  ),
)
.addTemplate(
  template.new(
  'service',
  'Prometheus',
  'label_values(mysql_global_variables_tokudb_cache_size{node_name=~"$host"}, service_name)',
  label='Service',
  refresh='load',
  sort=0,
  multi=false,
  skipUrlSync=false,
  definition='label_values(mysql_global_variables_tokudb_cache_size{node_name=~"$host"}, service_name)',
  includeAll=false,
  ),
)
.addPanel(
  text.new(
    content="<h1><i><font color=#5991A7><b><center>Data for </font><font color=#e68a00>$host</font> <font color=#5991A7> with</font> </font><font color=#e68a00>$interval</font> <font color=#5991A7>resolution</center></b></font></i></h1>",
    mode='html',
  ),
  gridPos={
        "h": 2,
        "w": 24,
        "x": 0,
        "y": 0,
      },
  style=null,
)//24 text
.addPanel(
  singlestat.new(
    'TokuDB Cache Size',//title
    format='bytes',
    editable=true,
    decimals=0,
    datasource='Prometheus',
    valueName='current',
    thresholds='90,95',
    colors=[
      "rgba(50, 172, 45, 0.97)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(245, 54, 54, 0.9)",
    ],
    interval='$interval',
    height='125px',
    prefixFontSize='80%',
    valueMaps=[],
  )
  .addTarget(
    prometheus.target(
      'mysql_global_variables_tokudb_cache_size{service_name="$service"}',
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
        "y": 2
  },
  style=null,
)//10 singlestat
.addPanel(
  singlestat.new(
    'TokuDB Block Size',//title
    format='bytes',
    editable=true,
    decimals=0,
    datasource='Prometheus',
    valueName='current',
    thresholds='90,95',
    colors=[
      "rgba(50, 172, 45, 0.97)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(245, 54, 54, 0.9)",
    ],
    interval='$interval',
    height='125px',
    prefixFontSize='80%',
    valueMaps=[],
  )
  .addTarget(
    prometheus.target(
      'mysql_global_variables_tokudb_block_size{service_name="$service"}',
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
        "x": 3,
        "y": 2,
  },
  style=null,
)//25 singlestat
.addPanel(
  singlestat.new(
    'TokuDB Block Size',//title
    format='bytes',
    editable=true,
    decimals=0,
    datasource='Prometheus',
    valueName='current',
    thresholds='90,95',
    colors=[
      "rgba(50, 172, 45, 0.97)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(245, 54, 54, 0.9)",
    ],
    interval='$interval',
    height='125px',
    prefixFontSize='80%',
    valueMaps=[],
  )
  .addTarget(
    prometheus.target(
      'mysql_global_variables_tokudb_read_block_size{service_name="$service"}',
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
        "x": 6,
        "y": 2,
  },
  style=null,
)//26 singlestat
.addPanel(
  singlestat.new(
    'TokuDB FanOut',//title
    format='short',
    editable=true,
    decimals=0,
    datasource='Prometheus',
    valueName='current',
    thresholds='90,95',
    colors=[
      "rgba(50, 172, 45, 0.97)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(245, 54, 54, 0.9)",
    ],
    interval='$interval',
    height='125px',
    prefixFontSize='80%',
    valueMaps=[],
  )
  .addTarget(
    prometheus.target(
      'mysql_global_variables_tokudb_fanout{service_name="$service"}',
      intervalFactor = 1,
      refId='A',
      interval='5m',
      calculatedInterval='10m',
      step=300,
    )
  ),
  gridPos = {
        "h": 2,
        "w": 2,
        "x": 9,
        "y": 2,
  },
  style=null,
)//27 singlestat
.addPanel(
  singlestat.new(
    'TokuDB Checkpoint Period',//title
    format='s',
    editable=true,
    decimals=0,
    datasource='Prometheus',
    valueName='current',
    thresholds='90,95',
    colors=[
      "rgba(50, 172, 45, 0.97)",
      "rgba(237, 129, 40, 0.89)",
      "rgba(245, 54, 54, 0.9)",
    ],
    interval='$interval',
    height='125px',
    prefixFontSize='80%',
    valueMaps=[],
  )
  .addTarget(
    prometheus.target(
      'mysql_global_variables_tokudb_checkpointing_period{service_name="$service"}',
      intervalFactor = 1,
      refId='A',
      interval='5m',
      calculatedInterval='10m',
      step=300,
    )
  ),
  gridPos = {
    "h": 2,
   "w": 4,
   "x": 11,
   "y": 2,
  },
  style=null,
)//28 singlestat
.addPanel(
  singlestat.new(
    'TokuDB Flush Log on Commit',//title
    format='short',
    editable=true,
    decimals=0,
    datasource='Prometheus',
    valueName='current',
    thresholds='0.5,1',
    colorValue=true,
    colors=[
        "rgba(245, 54, 54, 0.9)",
        "rgba(237, 129, 40, 0.89)",
        "rgba(50, 172, 45, 0.97)"
    ],
    interval='$interval',
    height='125px',
    prefixFontSize='80%',
    valueMaps=[
        {
          "op": "=",
          "text": "OFF",
          "value": "0"
        },
        {
          "op": "=",
          "text": "ON",
          "value": "1"
        }
      ],
  )
  .addTarget(
    prometheus.target(
      'mysql_global_variables_tokudb_commit_sync{service_name="$service"}',
      intervalFactor = 1,
      refId='A',
      interval='5m',
      calculatedInterval='10m',
      step=300,
    )
  ),
  gridPos = {
    "h": 2,
   "w": 4,
   "x": 15,
   "y": 2,
  },
  style=null,
)//29 singlestat
.addPanel(
  singlestat.new(
    'TokuDB DirectIO',//title
    format='short',
    editable=true,
    decimals=0,
    datasource='Prometheus',
    valueName='current',
    thresholds='90,95',
    colorValue=false,
    colors=[
      "rgba(50, 172, 45, 0.97)",
     "rgba(237, 129, 40, 0.89)",
     "rgba(245, 54, 54, 0.9)"
    ],
    interval='$interval',
    height='125px',
    prefixFontSize='80%',
    valueMaps=[
        {
          "op": "=",
          "text": "OFF",
          "value": "0"
        },
        {
          "op": "=",
          "text": "ON",
          "value": "1"
        }
      ],
  )
  .addTarget(
    prometheus.target(
      'mysql_global_variables_tokudb_directio{service_name="$service"}',
      intervalFactor = 1,
      refId='A',
      interval='5m',
      calculatedInterval='10m',
      step=300,
    )
  ),
  gridPos = {
    "h": 2,
   "w": 2,
   "x": 19,
   "y": 2,
  },
  style=null,
)//30 singlestat
.addPanel(
  singlestat.new(
    'Current Compression Ratio',//title
    format='short',
    editable=true,
    decimals=2,
    datasource='Prometheus',
    valueName='current',
    thresholds='90,95',
    colorValue=false,
    colors=[
      "rgba(50, 172, 45, 0.97)",
     "rgba(237, 129, 40, 0.89)",
     "rgba(245, 54, 54, 0.9)"
    ],
    interval='$interval',
    height='125px',
    prefixFontSize='80%',
    valueMaps=[],
  )
  .addTarget(
    prometheus.target(
      'mysql_global_status_tokudb_overall_node_compression_ratio{service_name="$service"}',
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
        "x": 21,
        "y": 2
  },
  style=null,
)//31 singlestat
.addPanel(
    row.new(
      title='Operations',
      collapse=true,
    )
    .addPanel(
      graphPanel.new(
        'TokuDB Transactions',//title
        fill=2,
        linewidth=2,
        decimals=2,
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
        value_type='cumulative',
        formatY1='ops',
        min=0,
        aliasColors={
            "Read Only Transactions Started": "#70dbed",
            "Transactions Aborted": "#bf1b00",
            "Transactons Committed": "#705da0"
          },
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_txn_begin{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_txn_begin{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Transactions Started',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_txn_begin_read_only{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_txn_begin_read_only{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Read Only Transactions Started',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_txn_commits{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_txn_commits{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Transactons Committed',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_txn_aborts{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_txn_aborts{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Transactions Aborted',
          )
      ),
      gridPos={
        "h": 7,
         "w": 12,
         "x": 0,
         "y": 5
      }
    )//2 graph
    .addPanel(
      graphPanel.new(
        'TokuDB Messages',//title
        fill=2,
        linewidth=2,
        decimals=2,
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
        formatY1='ops',
        labelY1='Messages',
        formatY2='Bps',
        labelY2='Message Size',
        min=0,
      )
      .addSeriesOverride({
              "alias": "Total Size of Messages Injected",
              "yaxis": 2
            })
      .addSeriesOverride( {
              "alias": "Total Size of Messages Flushed to Leaves",
              "yaxis": 2
            })
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_messages_injected_at_root{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_messages_injected_at_root{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Normal Messages Injected',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_broadcase_messages_injected_at_root{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_broadcase_messages_injected_at_root{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Broadcase Messages Injected',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_messages_injected_at_root_bytes{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_messages_injected_at_root_bytes{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Total Size of Messages Injected',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_messages_flushed_from_h1_to_leaves_bytes{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_messages_flushed_from_h1_to_leaves_bytes{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Total Size of Messages Flushed to Leaves',
            step=300,
          )
      ),
      gridPos={
        "h": 7,
         "w": 12,
         "x": 12,
         "y": 5
      }
    )//52 graph
    .addPanel(
      graphPanel.new(
        'TokuDB Compression/Serialization Resource Usage',//title
        fill=2,
        linewidth=2,
        decimals=2,
        bars=true,
        lines=false,
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
        stack=true,
        labelY1='Load',
        min=0,
        aliasColors={
            "Read Only Transactions Started": "#70dbed",
            "Transactions Aborted": "#bf1b00",
            "Transactons Committed": "#705da0"
          },
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_leaf_compression_to_memory_seconds{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_leaf_compression_to_memory_seconds{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Leaf Compression Load',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_leaf_decompression_to_memory_seconds{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_leaf_decompression_to_memory_seconds{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Leaf Decompression Load',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_leaf_serialization_to_memory_seconds{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_leaf_serialization_to_memory_seconds{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Leaf Serialization Load',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_leaf_deserialization_to_memory_seconds{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_leaf_deserialization_to_memory_seconds{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Leaf Deserialization Load',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_nonleaf_compression_to_memory_seconds{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_nonleaf_compression_to_memory_seconds{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Non Leaf Compression Load',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_nonleaf_decompression_to_memory_seconds{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_nonleaf_decompression_to_memory_seconds{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Non Leaf Decompression Load',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_nonleaf_serialization_to_memory_seconds{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_nonleaf_serialization_to_memory_seconds{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Non Leaf Serialization Load',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_nonleaf_deserialization_to_memory_seconds{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_nonleaf_deserialization_to_memory_seconds{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Non Lead Deserialization',
          )
      ),
      gridPos={
          "h": 7,
           "w": 12,
           "x": 0,
           "y": 12
      }
    )//51 graph
    .addPanel(
      graphPanel.new(
        'TokuDB Injections',//title
        fill=2,
        linewidth=2,
        decimals=2,
        bars=true,
        lines=false,
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
        stack=true,
        formatY1='ops',
        min=0,
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_promotion_injections_at_depth_0{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_promotion_injections_at_depth_0{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Depth  0 Injections',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_promotion_injections_at_depth_1{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_promotion_injections_at_depth_1{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Depth 1 Injections',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_promotion_injections_at_depth_2{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_promotion_injections_at_depth_2{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Depth 2 Injections',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_promotion_injections_at_depth_3{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_promotion_injections_at_depth_3{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Depth 3 Injections',
            step=300,
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_promotion_injections_lower_than_depth_3{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_promotion_injections_lower_than_depth_3{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Depth Lower than 3 Injections',
          )
      ),
      gridPos={
          "h": 7,
           "w": 12,
           "x": 12,
           "y": 12
      }
    )//12 graph
    .addPanel(
      graphPanel.new(
        'TokuDB Promotion Stopped Reason',//title
        fill=2,
        linewidth=2,
        decimals=2,
        bars=true,
        lines=false,
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
        stack=true,
        formatY1='ops',
        min=0,
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_promotion_stopped_nonempty_buffer{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_promotion_stopped_nonempty_buffer{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Non Empty Buffer',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_promotion_stopped_at_height_1{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_promotion_stopped_at_height_1{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Reached Height 1',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_promotion_stopped_child_locked_or_not_in_memory{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_promotion_stopped_child_locked_or_not_in_memory{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Child Locked or Not in Memory',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_promotion_stopped_child_not_fully_in_memory{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_promotion_stopped_child_not_fully_in_memory{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Child Not Fully in Memory',
            step=300,
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_promotion_stopped_after_locking_child{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_promotion_stopped_after_locking_child{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='After Locking Child',
            step=300,
          )
      ),
      gridPos={
          "h": 7,
           "w": 12,
           "x": 0,
           "y": 19
      }
    )//13 graph
    .addPanel(
      graphPanel.new(
        'TokuDB Nodes',//title
        fill=2,
        linewidth=2,
        decimals=2,
        bars=true,
        lines=false,
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
        stack=true,
        formatY1='ops',
        min=0,
        aliasColors={
            "Read Only Transactions Started": "#70dbed",
            "Transactions Aborted": "#bf1b00",
            "Transactons Committed": "#705da0"
          },
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_leaf_nodes_created{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_leaf_nodes_created{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Leaf Nodes Created',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_nonleaf_nodes_created{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_nonleaf_nodes_created{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Non Leaf Nodes Created',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_leaf_nodes_destroyed{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_leaf_nodes_destroyed{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Leaf Nodes Destroyed',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_nonleaf_nodes_destroyed{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_nonleaf_nodes_destroyed{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Non Leaf Nodes Destroyed',
          )
      ),
      gridPos={
          "h": 7,
           "w": 12,
           "x": 12,
           "y": 19
      }
    )//50 graph
    .addPanel(
      graphPanel.new(
        'TokuDB Wasteful Activities',//title
        fill=2,
        linewidth=2,
        decimals=2,
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
        formatY1='ops',
        formatY2='percentunit',
        min=0,
        aliasColors={
            "Leafs Garbage Percent (1h avg)": "#e0752d",
            "Leaves Garbage Percent (1h avg)": "#f9934e"
          },
      )
      .addSeriesOverride({
              "alias": "Leaves Garbage Percent (1h avg)",
              "fill": 0,
              "yaxis": 2
            })
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_messages_ignored_by_leaf_due_to_msn{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_messages_ignored_by_leaf_due_to_msn{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Duplicate Messages Delivered to Leaves',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_cursor_skip_deleted_leaf_entry{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_cursor_skip_deleted_leaf_entry{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Deleted Leaf Entries Scanned',
          )
      )
      .addTarget(
          prometheus.target(
            '1-rate(mysql_global_status_tokudb_leaf_entry_apply_gc_bytes_out{service_name="$service"}[1h])/rate(mysql_global_status_tokudb_leaf_entry_apply_gc_bytes_in{service_name="$service"}[1h])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Leaves Garbage Percent (1h avg)',
          )
      ),
      gridPos={
        "h": 7,
          "w": 12,
          "x": 0,
          "y": 26
      }
    )//66 graph
    .addPanel(
      graphPanel.new(
        'TokuDB Open Databases',//title
        fill=2,
        linewidth=2,
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
        value_type='cumulative',
        min=0,
        aliasColors={
            "TokuDB Databases Currently Open": "#70dbed"
          },
      )
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_global_status_tokudb_db_open_current{service_name="$service"}[$interval]) or max_over_time(mysql_global_status_tokudb_db_open_current{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='TokuDB Databases Currently Open',
          )
      )
      .addTarget(
          prometheus.target(
            'mysql_global_status_tokudb_db_open_max{service_name="$service"}',
            intervalFactor=1,
            legendFormat='Max TokuDB Open Databases',
          )
      ),
      gridPos={
        "h": 7,
          "w": 12,
          "x": 12,
          "y": 26
      }
    )//3 graph
    ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 4,
    },
    style=null,
)//35 row
.addPanel(
    row.new(
      title='Caching',
      collapse=true,
    )
    .addPanel(
      graphPanel.new(
        'TokuDB CacheTable Overview',//title
        fill=2,
        linewidth=2,
        decimals=2,
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
        stack=true,
        formatY1='bytes',
        min=0,
        aliasColors={
            "CacheTable Size Current": "#508642",
            "CacheTable Size Limit": "#bf1b00",
            "Caching Non Leaf Data": "#705da0"
          },
      )
      .addSeriesOverride({
                            "alias": "CacheTable Size Limit",
                            "stack": false
                        })
      .addSeriesOverride({
                            "alias": "CacheTable Size Current",
                            "stack": false
                        })
      .addTarget(
          prometheus.target(
            '{__name__=~"mysql_global_status_tokudb_cachetable_size_.+", service_name="$service"}',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='{{ __name__ }}',
            hide=true,
          )
      )
      .addTarget(
          prometheus.target(
            'mysql_global_status_tokudb_cachetable_size_limit{service_name="$service"}',
            interval='$interval',
            intervalFactor=1,
            legendFormat='CacheTable Size Limit',
          )
      )
      .addTarget(
          prometheus.target(
            'mysql_global_status_tokudb_cachetable_size_current{service_name="$service"}',
            interval='$interval',
            intervalFactor=1,
            legendFormat='CacheTable Size Current',
          )
      )
      .addTarget(
          prometheus.target(
            'mysql_global_status_tokudb_cachetable_size_leaf{service_name="$service"}',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Caching Leaf Data',
          )
      )
      .addTarget(
          prometheus.target(
            'mysql_global_status_tokudb_cachetable_size_nonleaf{service_name="$service"}',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Caching Non Leaf Data',
          )
      ),
      gridPos={
        "h": 7,
         "w": 12,
         "x": 0,
         "y": 6
      }
    )//1 graph
    .addPanel(
      graphPanel.new(
        'TokuDB CacheTable Special',//title
        fill=0,
        linewidth=1,
        decimals=2,
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
        value_type='cumulative',
        formatY1='bytes',
        min=0,
        aliasColors={
            "Cloned CacheTable Size": "#f9934e",
            "Rollback CacheTable Size": "#82b5d8",
            "Writing CacheTable Size": "#bf1b00"
          },
      )
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_global_status_tokudb_cachetable_size_cloned{service_name="$service"}[$interval]) or max_over_time(mysql_global_status_tokudb_cachetable_size_cloned{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Cloned CacheTable Size',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_global_status_tokudb_cachetable_size_rollback{service_name="$service"}[$interval]) or max_over_time(mysql_global_status_tokudb_cachetable_size_rollback{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Rollback CacheTable Size',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_global_status_tokudb_cachetable_size_writing{service_name="$service"}[$interval]) or max_over_time(mysql_global_status_tokudb_cachetable_size_writing{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Writing CacheTable Size',
          )
      ),
      gridPos={
        "h": 7,
         "w": 12,
         "x": 12,
         "y": 6
      }
    )//40 graph
    .addPanel(
      graphPanel.new(
        'Cache Pressure',//title
        fill=2,
        linewidth=2,
        decimals=2,
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
        value_type='cumulative',
        min=0,
        decimalsY1=2,
        aliasColors={
            "Cache Pressure Ratio": "#ef843c"
          },
      )
      .addTarget(
          prometheus.target(
            'mysql_global_status_tokudb_cachetable_size_cachepressure{service_name="$service"}/mysql_global_status_tokudb_cachetable_size_current{service_name="$service"}',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Cache Pressure Ratio',
            step=300,
          )
      ),
      gridPos={
            "h": 7,
              "w": 12,
              "x": 0,
              "y": 13
      }
    )//41 graph
    .addPanel(
      graphPanel.new(
        'CacheTable Events',//title
        fill=0,
        linewidth=1,
        decimals=2,
        datasource='Prometheus',
        lines=false,
        points=true,
        pointradius=1,
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
        decimalsY1=2,
        labelY1='Misses/Evictions',
        labelY2='Misses Load',
        aliasColors={
            "Cache Pressure Ratio": "#ef843c",
            "Evictions": "#c15c17",
            "Misses Load ": "#bf1b00",
            "Prefetches": "#70dbed"
          },
      )
      .addSeriesOverride({
              "alias": "Misses Load ",
              "lines": true,
              "points": false,
              "yaxis": 2
            })
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_cachetable_evictions{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_cachetable_evictions{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Evictions',
            step=300,
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_cachetable_miss{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_cachetable_miss{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Misses',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_cachetable_miss_time{service_name="$service"}[$interval])/1000000 or irate(mysql_global_status_tokudb_cachetable_miss_time{service_name="$service"}[5m])/100000',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Misses Load',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_cachetable_prefetches{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_cachetable_prefetches{service_name="$service"}[$interval])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Prefetches',
          )
      ),
      gridPos={
            "h": 7,
              "w": 12,
              "x": 12,
              "y": 13
      }
    )//42 graph
    .addPanel(
      graphPanel.new(
        'Partial Evictions',//title
        fill=2,
        linewidth=1,
        decimals=2,
        datasource='Prometheus',
        lines=false,
        bars=true,
        pointradius=1,
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
        decimalsY1=2,
        labelY1='Eviction Counts',
        labelY2='Evicted Bytes',
        formatY2='Bps',
        aliasColors={
            "Cache Pressure Ratio": "#ef843c",
            "Evictions": "#c15c17",
            "Leaf Partial Evictions": "#e0752d",
            "Misses Load ": "#bf1b00"
          },
      )
      .addSeriesOverride({
              "alias": "Evicted Bytes",
              "bars": false,
              "lines": true,
              "stack": false,
              "yaxis": 2
            })
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_leaf_node_partial_evictions{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_leaf_node_partial_evictions{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Leaf Partial Evictions',
            step=300,
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_nonleaf_node_partial_evictions{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_nonleaf_node_partial_evictions{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Non Leaf Partial Evictions',
          )
      )
      .addTarget(
          prometheus.target(
            '(rate(mysql_global_status_tokudb_leaf_node_partial_evictions_bytes{service_name="$service"}[$interval]) + rate(mysql_global_status_tokudb_nonleaf_node_partial_evictions_bytes{service_name="$service"}[$interval])) or (irate(mysql_global_status_tokudb_leaf_node_partial_evictions_bytes{service_name="$service"}[5m]) + irate(mysql_global_status_tokudb_nonleaf_node_partial_evictions_bytes{service_name="$service"}[5m]))',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Evicted Bytes',
          )
      ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 0,
        "y": 20
      }
    )//43 graph
    .addPanel(
      graphPanel.new(
        'Full Evictions',//title
        fill=2,
        linewidth=1,
        decimals=2,
        datasource='Prometheus',
        lines=false,
        bars=true,
        pointradius=1,
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
        decimalsY1=2,
        labelY1='Eviction Counts',
        labelY2='Evicted Bytes',
        formatY2='Bps',
        aliasColors={
            "Cache Pressure Ratio": "#ef843c",
            "Evictions": "#c15c17",
            "Leaf Full Evictions": "#e0752d",
            "Leaf Partial Evictions": "#e0752d",
            "Misses Load ": "#bf1b00"
          },
      )
      .addSeriesOverride({
              "alias": "Evicted Bytes",
              "bars": false,
              "lines": true,
              "stack": false,
              "yaxis": 2
            })
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_leaf_node_full_evictions{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_leaf_node_full_evictions{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Leaf Full Evictions',
            step=300,
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_nonleaf_node_full_evictions{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_nonleaf_node_full_evictions{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Non Leaf Full Evictions',
          )
      )
      .addTarget(
          prometheus.target(
            '(rate(mysql_global_status_tokudb_leaf_node_full_evictions_bytes{service_name="$service"}[$interval]) + rate(mysql_global_status_tokudb_nonleaf_node_full_evictions_bytes{service_name="$service"}[$interval])) or (irate(mysql_global_status_tokudb_leaf_node_full_evictions_bytes{service_name="$service"}[5m]) + irate(mysql_global_status_tokudb_nonleaf_node_full_evictions_bytes{service_name="$service"}[5m]))',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Evicted Bytes',
          )
      ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 12,
        "y": 20
      }
    )//44 graph
    ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 5,
    },
    style=null,
)//39 row
.addPanel(
    row.new(
      title='Checkpointing and Flushing',
      collapse=true,
    )
    .addPanel(
      graphPanel.new(
        'TokuDB Checkpointing Summary',//title
        fill=2,
        linewidth=2,
        decimals=2,
        lines=false,
        points=true,
        datasource='Prometheus',
        pointradius=1,
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
        labelY1='Load',
        formatY2='ops',
        min=0,
        aliasColors={
            "Critical Section (Begin) Load": "#bf1b00"
          },
      )
      .addSeriesOverride({
              "alias": "Avg Checkpoint Load (1h)",
              "fill": 0,
              "lines": true,
              "linewidth": 1,
              "points": false
            })
      .addSeriesOverride({
              "alias": "Checkpoints Taken",
              "yaxis": 2
            })
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_checkpoint_taken{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_checkpoint_taken{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Checkpoints Taken',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_checkpoint_duration{service_name="$service"}[1h])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Avg Checkpoint Load (1h)',
            step=300,
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_checkpoint_begin_time{service_name="$service"}[$interval])/1000000 or irate(mysql_global_status_tokudb_checkpoint_begin_time{service_name="$service"}[5m])/1000000',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Critical Section (Begin) Load',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_checkpoint_end_time{service_name="$service"}[$interval])/1000000 or irate(mysql_global_status_tokudb_checkpoint_end_time{service_name="$service"}[5m])/1000000',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Non Critical Section (End) Load',
          )
      )
      .addTarget(
          prometheus.target(
            '(rate(mysql_global_status_tokudb_leaf_nodes_flushed_checkpoint_seconds{service_name="$service"}[$interval])+rate(mysql_global_status_tokudb_nonleaf_nodes_flushed_to_disk_checkpoint_seconds{service_name="$service"}[$interval])) or (irate(mysql_global_status_tokudb_leaf_nodes_flushed_checkpoint_seconds{service_name="$service"}[5m])+irate(mysql_global_status_tokudb_nonleaf_nodes_flushed_to_disk_checkpoint_seconds{service_name="$service"}[5m]))',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Disk Flush Load',
          )
      ),
      gridPos={
        "h": 7,
         "w": 12,
         "x": 0,
         "y": 7
      }
    )//9 graph
    .addPanel(
      graphPanel.new(
        'TokuDB Checkpoint Size',//title
        fill=2,
        linewidth=2,
        decimals=2,
        lines=false,
        bars=true,
        datasource='Prometheus',
        pointradius=1,
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
        labelY1='Avg Time',
        formatY1='s',
        formatY2='bytes',
        min=0,
        aliasColors={
            "Avg Critical Section Time": "#bf1b00",
            "Bytes Flushed Per Checkpoint": "#705da0",
            "Bytes Flushed Per Checkpoint (1h avg)": "#70dbed",
            "Critical Section (Begin) Load": "#bf1b00",
            "Uncompressed Data Processed Per Checkpoint": "#70dbed"
          },
      )
      .addSeriesOverride({
              "alias": "Uncompressed Data Processed Per Checkpoint (1h avg)",
              "bars": false,
              "fill": 0,
              "lines": true,
              "stack": false,
              "yaxis": 2
            })
      .addSeriesOverride({
              "alias": "Bytes Flushed Per Checkpoint (1h avg)",
              "bars": false,
              "fill": 0,
              "lines": true,
              "stack": false,
              "yaxis": 2
            })
      .addTarget(
          prometheus.target(
            '(rate(mysql_global_status_tokudb_checkpoint_begin_time{service_name="$service"}[$interval])/1000000/rate(mysql_global_status_tokudb_checkpoint_taken{service_name="$service"}[$interval])) or (irate(mysql_global_status_tokudb_checkpoint_begin_time{service_name="$service"}[5m])/1000000/irate(mysql_global_status_tokudb_checkpoint_taken{service_name="$service"}[5m]))',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Avg Critical Section Time',
          )
      )
      .addTarget(
          prometheus.target(
            '(rate(mysql_global_status_tokudb_checkpoint_end_time{service_name="$service"}[$interval])/1000000/rate(mysql_global_status_tokudb_checkpoint_taken{service_name="$service"}[$interval])) or ((irate(mysql_global_status_tokudb_checkpoint_end_time{service_name="$service"}[5m])/1000000/irate(mysql_global_status_tokudb_checkpoint_taken{service_name="$service"}[5m])))',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Avg Non Critical Section Time',
          )
      )
      .addTarget(
          prometheus.target(
            '(rate(mysql_global_status_tokudb_leaf_nodes_flushed_checkpoint_bytes{service_name="$service"}[1h])+rate(mysql_global_status_tokudb_nonleaf_nodes_flushed_to_disk_checkpoint_bytes{service_name="$service"}[1h]))/rate(mysql_global_status_tokudb_checkpoint_taken{service_name="$service"}[1h])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Bytes Flushed Per Checkpoint (1h avg)',
          )
      )
      .addTarget(
          prometheus.target(
            '(rate(mysql_global_status_tokudb_leaf_nodes_flushed_checkpoint_uncompressed_bytes{service_name="$service"}[1h])+rate(mysql_global_status_tokudb_nonleaf_nodes_flushed_to_disk_checkpoint_uncompressed_by{service_name="$service"}[1h]))/rate(mysql_global_status_tokudb_checkpoint_taken{service_name="$service"}[1h])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Uncompressed Data Processed Per Checkpoint (1h avg)',
          )
      ),
      gridPos={
        "h": 7,
         "w": 12,
         "x": 12,
         "y": 7
      }
    )//48 graph
    .addPanel(
      graphPanel.new(
        'Checkpoint Flushing',//title
        fill=2,
        linewidth=2,
        decimals=2,
        lines=false,
        bars=true,
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
        stack=true,
        formatY1='Bps',
        min=0,
      )
      .addSeriesOverride({
              "alias": "Checkpoint Flushed Total",
              "bars": false,
              "stack": false
            })
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_leaf_nodes_flushed_checkpoint_bytes{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_leaf_nodes_flushed_checkpoint_bytes{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Leaf Nodes Flushed Bytes',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_nonleaf_nodes_flushed_to_disk_checkpoint_bytes{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_nonleaf_nodes_flushed_to_disk_checkpoint_bytes{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Non Lead Nodes Flushed Bytes',
            step=300,
          )
      )
      .addTarget(
          prometheus.target(
            '(rate(mysql_global_status_tokudb_leaf_nodes_flushed_checkpoint_bytes{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_leaf_nodes_flushed_checkpoint_bytes{service_name="$service"}[5m])) + (rate(mysql_global_status_tokudb_nonleaf_nodes_flushed_to_disk_checkpoint_bytes{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_nonleaf_nodes_flushed_to_disk_checkpoint_bytes{service_name="$service"}[5m]))',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Checkpoint Flushed Total',
          )
      ),
      gridPos={
          "h": 6,
            "w": 12,
            "x": 0,
            "y": 14
      }
    )//45 graph
    .addPanel(
      graphPanel.new(
        'Not-Checkpoint Flushing',//title
        fill=2,
        linewidth=2,
        decimals=2,
        lines=false,
        bars=true,
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
        stack=true,
        formatY1='Bps',
        min=0,
      )
      .addSeriesOverride({
              "alias": "Not Checkpoint Flushed Total",
              "bars": false,
              "stack": false
            })
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_leaf_nodes_flushed_not_checkpoint_bytes{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_leaf_nodes_flushed_not_checkpoint_bytes{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Leaf Nodes Flushed Bytes',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_nonleaf_nodes_flushed_to_disk_not_checkpoint_bytes{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_nonleaf_nodes_flushed_to_disk_not_checkpoint_bytes{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Non Lead Nodes Flushed Bytes',
            step=300,
          )
      )
      .addTarget(
          prometheus.target(
            '(rate(mysql_global_status_tokudb_leaf_nodes_flushed_not_checkpoint_bytes{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_leaf_nodes_flushed_not_checkpoint_bytes{service_name="$service"}[5m])) + (rate(mysql_global_status_tokudb_nonleaf_nodes_flushed_to_disk_not_checkpoint_bytes{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_nonleaf_nodes_flushed_to_disk_not_checkpoint_bytes{service_name="$service"}[5m]))',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Not Checkpoint Flushed Total',
          )
      ),
      gridPos={
          "h": 6,
            "w": 12,
            "x": 12,
            "y": 14
      }
    )//47 graph
    .addPanel(
      graphPanel.new(
        'Avg Flushed Node Size',//title
        fill=2,
        linewidth=2,
        decimals=2,
        lines=false,
        points=true,
        datasource='Prometheus',
        pointradius=1,
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
        formatY1='bytes',
        min=0,
        aliasColors={
            "Critical Section (Begin) Load": "#bf1b00",
            "Flushed Leaf Node Size": "#705da0",
            "Flushed Non Leaf Node Size": "#1f78c1"
          },
      )
      .addSeriesOverride({
              "alias": "Avg Checkpoint Load (1h)",
              "fill": 0,
              "lines": true,
              "linewidth": 1,
              "points": false
            })
      .addTarget(
          prometheus.target(
            '(rate(mysql_global_status_tokudb_nonleaf_nodes_flushed_to_disk_checkpoint_bytes{service_name="$service"}[$interval])+rate(mysql_global_status_tokudb_nonleaf_nodes_flushed_to_disk_not_checkpoint_bytes{service_name="$service"}[$interval]))/(rate(mysql_global_status_tokudb_nonleaf_nodes_flushed_to_disk_checkpoint{service_name="$service"}[$interval])+rate(mysql_global_status_tokudb_nonleaf_nodes_flushed_to_disk_not_checkpoint{service_name="$service"}[$interval]))',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Flushed Non Leaf Node Size',
          )
      )
      .addTarget(
          prometheus.target(
            '(rate(mysql_global_status_tokudb_leaf_nodes_flushed_checkpoint_bytes{service_name="$service"}[$interval])+rate(mysql_global_status_tokudb_leaf_nodes_flushed_not_checkpoint_bytes{service_name="$service"}[$interval]))/(rate(mysql_global_status_tokudb_leaf_nodes_flushed_checkpoint{service_name="$service"}[$interval])+rate(mysql_global_status_tokudb_leaf_nodes_flushed_not_checkpoint{service_name="$service"}[$interval]))',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Flushed Leaf Node Size',
            step=300,
          )
      )
      .addTarget(
          prometheus.target(
            '',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Critical Section (Begin) Load',
            hide=true,
          )
      ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 0,
        "y": 20
      }
    )//46 graph
    .addPanel(
      graphPanel.new(
        'Flushing Disk Load',//title
        fill=2,
        linewidth=2,
        decimals=2,
        lines=false,
        bars=true,
        datasource='Prometheus',
        pointradius=1,
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
        labelY1='Load',
        min=0,
        aliasColors={
            "Critical Section (Begin) Load": "#bf1b00",
            "Flushed Leaf Node Size": "#705da0",
            "Flushed Non Leaf Node Size": "#1f78c1"
          },
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_leaf_nodes_flushed_checkpoint_seconds{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_leaf_nodes_flushed_checkpoint_seconds{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Leaf Nodes Checkpoint',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_nonleaf_nodes_flushed_to_disk_checkpoint_seconds{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_nonleaf_nodes_flushed_to_disk_checkpoint_seconds{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Non Leaf Nodes Checkpoint',
            step=300,
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_leaf_nodes_flushed_not_checkpoint_seconds{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_leaf_nodes_flushed_not_checkpoint_seconds{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Leaf Nodes Not Checkpoint',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_nonleaf_nodes_flushed_to_disk_not_checkpoint_seconds{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_nonleaf_nodes_flushed_to_disk_not_checkpoint_seconds{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Non Leaf Nodes Not Checkpoint',
          )
      ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 12,
        "y": 20
      }
    )//49 graph
    ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 6,
    },
    style=null,
)//37 row
.addPanel(
    row.new(
      title='Pivots, Basements, Buffers',
      collapse=true,
    )
    .addPanel(
      graphPanel.new(
        'TokuDB Pivots Bytes',//title
        fill=2,
        linewidth=2,
        decimals=2,
        lines=false,
        bars=true,
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
        stack=true,
        format='Bps',
        min=0,
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_pivots_fetched_for_query_bytes{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_pivots_fetched_for_query_bytes{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Fetched for Query Pivots Size',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_pivots_fetched_for_prefetch_bytes{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_pivots_fetched_for_prefetch_bytes{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Fetched for Prefetch Pivots Size',
            step=300,
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_pivots_fetched_for_write_bytes{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_pivots_fetched_for_write_bytes{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Fetched for Write Pivots Size',
            step=300,
          )
      ),
      gridPos={
        "h": 7,
         "w": 12,
         "x": 0,
         "y": 8
      }
    )//53 graph
    .addPanel(
      graphPanel.new(
        'TokuDB Pivots Load',//title
        fill=2,
        linewidth=2,
        decimals=2,
        lines=false,
        bars=true,
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
        stack=true,
        labelY1='Load',
        formatY2='Bps',
        min=0,
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_pivots_fetched_for_query_seconds{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_pivots_fetched_for_query_seconds{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Fetched for Query Pivots Load',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_pivots_fetched_for_prefetch_seconds{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_pivots_fetched_for_prefetch_seconds{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Fetched for Prefetch Pivots Load',
            step=300,
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_pivots_fetched_for_write_seconds{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_pivots_fetched_for_write_seconds{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Fetched for Write Pivots Load',
            step=300,
          )
      ),
      gridPos={
        "h": 7,
         "w": 12,
         "x": 12,
         "y": 8
      }
    )//60 graph
    .addPanel(
      graphPanel.new(
        'TokuDB Basements Bytes',//title
        fill=2,
        linewidth=2,
        decimals=2,
        lines=false,
        bars=true,
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
        stack=true,
        format='Bps',
        min=0,
        aliasColors={
            "Fetched for Prefetch Basements Size": "#806eb7",
            "Fetched for Query Basements Size": "#f9d9f9",
            "Fetched for Write Basements Size": "#ba43a9",
            "Fetcvhed for Prelocked Range Basements Size": "#806eb7"
          },
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_basements_fetched_target_query_bytes{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_basements_fetched_target_query_bytes{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Fetched for Query Basements Size',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_basements_fetched_prefetch_bytes{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_basements_fetched_prefetch_bytes{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Fetched for Prefetch Basements Size',
            step=300,
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_basements_fetched_for_write_bytes{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_basements_fetched_for_write_bytes{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Fetched for Write Basements Size',
            step=300,
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_basements_fetched_prelocked_range_bytes{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_basements_fetched_prelocked_range_bytes{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Fetched for Prelocked Range Basements Size',
          )
      ),
      gridPos={
        "h": 7,
         "w": 12,
         "x": 0,
         "y": 15
      }
    )//61 graph
    .addPanel(
      graphPanel.new(
        'TokuDB Basements Load',//title
        fill=2,
        linewidth=2,
        decimals=2,
        lines=false,
        bars=true,
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
        stack=true,
        formatY2='Bps',
        labelY1='Load',
        min=0,
        aliasColors={
            "Fetched for Prefetch Basements Load": "#5195ce",
            "Fetched for Prefetch Basements Size": "#806eb7",
            "Fetched for Prelocked Range Basements Load": "#806eb7",
            "Fetched for Query Basements Load": "#f9d9f9",
            "Fetched for Query Basements Size": "#f9d9f9",
            "Fetched for Write Basements Load": "#ba43a9",
            "Fetched for Write Basements Size": "#ba43a9",
            "Fetcvhed for Prelocked Range Basements Size": "#806eb7"
          },
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_basements_fetched_target_query_seconds{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_basements_fetched_target_query_seconds{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Fetched for Query Basements Load',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_basements_fetched_prefetch_seconds{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_basements_fetched_prefetch_seconds{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Fetched for Prefetch Basements Load',
            step=300,
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_basements_fetched_for_write_seconds{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_basements_fetched_for_write_seconds{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Fetched for Write Basements Load',
            step=300,
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_basements_fetched_prelocked_range_seconds{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_basements_fetched_prelocked_range_seconds{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Fetched for Prelocked Range Basements Load',
          )
      ),
      gridPos={
        "h": 7,
         "w": 12,
         "x": 12,
         "y": 15
      }
    )//63 graph
    .addPanel(
      graphPanel.new(
        'TokuDB Buffers Bytes',//title
        fill=2,
        linewidth=2,
        decimals=2,
        lines=false,
        bars=true,
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
        stack=true,
        format='Bps',
        min=0,
        aliasColors={
            "Fetched for Prefetch Basements Size": "#806eb7",
            "Fetched for Query Basements Size": "#f9d9f9",
            "Fetched for Query Buffers Size": "#b7dbab",
            "Fetched for Write Basements Size": "#ba43a9",
            "Fetched for Write Buffers Size": "#ea6460",
            "Fetcvhed for Prelocked Range Basements Size": "#806eb7"
          },
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_buffers_fetched_target_query_bytes{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_buffers_fetched_target_query_bytes{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Fetched for Query Buffers Size',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_buffers_fetched_prefetch_bytes{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_buffers_fetched_prefetch_bytes{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Fetched for Prefetch Buffers Size',
            step=300,
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_buffers_fetched_for_write_bytes{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_buffers_fetched_for_write_bytes{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Fetched for Write Buffers Size',
            step=300,
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_buffers_fetched_prelocked_range_bytes{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_buffers_fetched_prelocked_range_bytes{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Fetched for Prelocked Range Buffers Size',
          )
      ),
      gridPos={
        "h": 7,
         "w": 12,
         "x": 0,
         "y": 22
      }
    )//64 graph
    .addPanel(
      graphPanel.new(
        'TokuDB Buffers Load',//title
        fill=2,
        linewidth=2,
        decimals=2,
        lines=false,
        bars=true,
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
        stack=true,
        formatY2='Bps',
        labelY1='Load',
        min=0,
        aliasColors={
            "Fetched for Prefetch Basements Load": "#5195ce",
            "Fetched for Prefetch Basements Size": "#806eb7",
            "Fetched for Prelocked Range Basements Load": "#806eb7",
            "Fetched for Query Basements Load": "#f9d9f9",
            "Fetched for Query Basements Size": "#f9d9f9",
            "Fetched for Query Buffers Load": "#b7dbab",
            "Fetched for Write Basements Load": "#ba43a9",
            "Fetched for Write Basements Size": "#ba43a9",
            "Fetched for Write Buffers Load": "#ea6460",
            "Fetcvhed for Prelocked Range Basements Size": "#806eb7"
          },
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_buffers_fetched_target_query_seconds{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_buffers_fetched_target_query_seconds{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Fetched for Query Buffers Load',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_buffers_fetched_prefetch_seconds{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_buffers_fetched_prefetch_seconds{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Fetched for Prefetch Buffers Load',
            step=300,
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_buffers_fetched_for_write_seconds{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_buffers_fetched_for_write_seconds{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Fetched for Write Buffers Load',
            step=300,
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_buffers_fetched_prelocked_range_seconds{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_buffers_fetched_prelocked_range_seconds{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Fetched for Prelocked Range Buffers Load',
          )
      ),
      gridPos={
        "h": 7,
         "w": 12,
         "x": 12,
         "y": 22
      }
    )//65 graph
    ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 7,
    },
    style=null,
)//33 row
.addPanel(
    row.new(
      title='Logger',
      collapse=true,
    )
    .addPanel(
      graphPanel.new(
        'TokuDB Logger',//title
        fill=2,
        linewidth=2,
        decimals=2,
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
        value_type='cumulative',
        formatY1='Bps',
        formatY2='iops',
        min=0,
      )
      .addSeriesOverride({
              "alias": "TokuDB WAL Writes",
              "yaxis": 2
            })
      .addSeriesOverride({
              "alias": "WAL Writes",
              "yaxis": 2
            })
      .addSeriesOverride({
              "alias": "Total Fsyncs  ",
              "yaxis": 2
            })
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_logger_writes_bytes{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_logger_writes_bytes{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Data written to WAL',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_logger_writes{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_logger_writes{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='WAL Writes',
            step=300,
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_filesystem_fsync_num{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_filesystem_fsync_num{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Total Fsyncs',
          )
      ),
      gridPos={
        "h": 7,
         "w": 12,
         "x": 0,
         "y": 9
      }
    )//16 graph
    .addPanel(
      graphPanel.new(
        'TokuDB Logger Load',//title
        fill=2,
        linewidth=2,
        decimals=2,
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
        value_type='cumulative',
        formatY1='short',
        formatY2='s',
        min=0,
      )
      .addSeriesOverride({
              "alias": "Fsync Avg Latency",
              "yaxis": 2
            })
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_logger_writes_seconds{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_logger_writes_seconds{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Logger Load',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_filesystem_fsync_time{service_name="$service"}[$interval])/1000000  or irate(mysql_global_status_tokudb_filesystem_fsync_time{service_name="$service"}[5m])/1000000',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Fsync Load',
            step=300,
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_filesystem_fsync_time{service_name="$service"}[$interval])/rate(mysql_global_status_tokudb_filesystem_fsync_num{service_name="$service"}[$interval])/1000000  or irate(mysql_global_status_tokudb_filesystem_fsync_time{service_name="$service"}[5m])/irate(mysql_global_status_tokudb_filesystem_fsync_num{service_name="$service"}[5m])/1000000',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Fsync Avg Latency',
          )
      ),
      gridPos={
        "h": 7,
         "w": 12,
         "x": 12,
         "y": 9
      }
    )//67 graph
    ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 8,
    },
    style=null,
)//59 row
.addPanel(
    row.new(
      title='LockTree',
      collapse=true,
    )
    .addPanel(
      graphPanel.new(
        'TokuDB LockTree Memory',//title
        fill=0,
        linewidth=2,
        decimals=2,
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
        value_type='cumulative',
        formatY1='bytes',
        min=0,
        aliasColors={
            "LockTree Memory Limit": "#bf1b00"
          },
      )
      .addSeriesOverride({
              "alias": "Fsync Avg Latency",
              "yaxis": 2
            })
      .addSeriesOverride({
              "alias": "Currently Open LockTrees",
              "yaxis": 2
            })
      .addTarget(
          prometheus.target(
            'mysql_global_status_tokudb_locktree_memory_size_limit{service_name="$service"}',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='LockTree Memory Limit',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_global_status_tokudb_locktree_memory_size{service_name="$service"}[$interval])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Current LockTree Size',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_global_status_tokudb_locktree_open_current{service_name="$service"}[$interval])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Currently Open LockTrees',
          )
      ),
      gridPos={
        "h": 7,
         "w": 12,
         "x": 0,
         "y": 10
      }
    )//80 graph
    .addPanel(
      graphPanel.new(
        'TokuDB LockTree Waits',//title
        fill=0,
        linewidth=2,
        decimals=2,
        datasource='Prometheus',
        pointradius=5,
        legend_values=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        editable=true,
        value_type='cumulative',
        formatY2='s',
        min=0,
        aliasColors={
            "Lock Wait Load": "#962d82",
            "LockTree Memory Limit": "#bf1b00",
            "Pending Lock Requests": "#614d93",
            "Pending Lock Requests ": "#705da0"
          },
      )
      .addSeriesOverride({
              "alias": "Pending Lock Requests",
              "lines": false,
              "pointradius": 1,
              "points": true
            })
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_global_status_tokudb_locktree_pending_lock_requests{service_name="$service"}[$interval])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Pending Lock Requests',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_locktree_wait_count{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_locktree_wait_count{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Current LockTree Size',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_locktree_wait_time{service_name="$service"}[$interval])/1000000 or irate(mysql_global_status_tokudb_locktree_wait_count{service_name="$service"}[5m])/1000000',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Lock Wait Load',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_locktree_timeout_count{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_locktree_timeout_count{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Lock Wait Timeouts',
          )
      ),
      gridPos={
        "h": 7,
         "w": 12,
         "x": 12,
         "y": 10
      }
    )//83 graph
    ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 9,
    },
    style=null,
)//75 row
.addPanel(
    row.new(
      title='Background Activity',
      collapse=true,
    )
    .addPanel(
      graphPanel.new(
        'TokuDB Client Thread Pool',//title
        fill=0,
        linewidth=1,
        decimals=2,
        datasource='Prometheus',
        pointradius=1,
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
        aliasColors={
            "Avg Threads Active": "#70dbed",
            "Cleaner Executions": "#70dbed",
            "Client Thread Pool Size": "#bf1b00",
            "Peak Threads Active": "#e5ac0e"
          },
      )
      .addSeriesOverride({
              "alias": "Peak Threads Active",
              "lines": false,
              "pointradius": 1,
              "points": true
            })
      .addTarget(
          prometheus.target(
            'mysql_global_status_tokudb_cachetable_pool_client_num_threads{service_name="$service"}',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Client Thread Pool Size',
          )
      )
      .addTarget(
          prometheus.target(
            'avg_over_time(mysql_global_status_tokudb_cachetable_pool_client_num_threads_active{service_name="$service"}[$interval])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Avg Threads Active',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_global_status_tokudb_cachetable_pool_client_num_threads_active{service_name="$service"}[$interval])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Peak Threads Active',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_global_status_tokudb_cachetable_pool_client_queue_size{service_name="$service"}[$interval])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Peak Queue Size',
          )
      ),
      gridPos={
        "h": 7,
         "w": 12,
         "x": 0,
         "y": 11
      }
    )//77 graph
    .addPanel(
      graphPanel.new(
        'TokuDB CacheTable Thread Pool',//title
        fill=0,
        linewidth=1,
        decimals=2,
        datasource='Prometheus',
        pointradius=1,
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
        aliasColors={
            "Avg Threads Active": "#70dbed",
            "CacheTable Thread Pool Size": "#bf1b00",
            "Cleaner Executions": "#70dbed",
            "Client Thread Pool Size": "#bf1b00",
            "Peak Threads Active": "#e5ac0e"
          },
      )
      .addSeriesOverride({
              "alias": "Peak Threads Active",
              "lines": false,
              "pointradius": 1,
              "points": true
            })
      .addTarget(
          prometheus.target(
            'mysql_global_status_tokudb_cachetable_pool_cachetable_num_threads{service_name="$service"}',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='CacheTable Thread Pool Size',
          )
      )
      .addTarget(
          prometheus.target(
            'avg_over_time(mysql_global_status_tokudb_cachetable_pool_cachetable_num_threads_active{service_name="$service"}[$interval])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Avg Threads Active',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_global_status_tokudb_cachetable_pool_cachetable_num_threads_active{service_name="$service"}[$interval])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Peak Threads Active',
          )
      ),
      gridPos={
        "h": 7,
         "w": 12,
         "x": 12,
         "y": 11
      }
    )//78 graph
    .addPanel(
      graphPanel.new(
        'TokuDB Checkpoint Thread Pool',//title
        fill=0,
        linewidth=1,
        decimals=2,
        datasource='Prometheus',
        pointradius=1,
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
        aliasColors={
            "Avg Threads Active": "#70dbed",
            "Checkpoint Thread Pool Size": "#bf1b00",
            "Cleaner Executions": "#70dbed",
            "Client Thread Pool Size": "#bf1b00",
            "Peak Threads Active": "#e5ac0e"
          },
      )
      .addSeriesOverride({
              "alias": "Peak Threads Active",
              "lines": false,
              "pointradius": 1,
              "points": true
            })
      .addTarget(
          prometheus.target(
            'mysql_global_status_tokudb_cachetable_pool_checkpoint_num_threads{service_name="$service"}',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Checkpoint Thread Pool Size',
          )
      )
      .addTarget(
          prometheus.target(
            'avg_over_time(mysql_global_status_tokudb_cachetable_pool_checkpoint_num_threads_active{service_name="$service"}[$interval])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Avg Threads Active',
          )
      )
      .addTarget(
          prometheus.target(
            'max_over_time(mysql_global_status_tokudb_cachetable_pool_checkpoint_num_threads_active{service_name="$service"}[$interval])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Peak Threads Active',
          )
      ),
      gridPos={
          "h": 7,
          "w": 12,
          "x": 0,
          "y": 18
      }
    )//79 graph
    .addPanel(
      graphPanel.new(
        'TokuDB Background Operations',//title
        fill=2,
        linewidth=2,
        decimals=2,
        points=true,
        lines=false,
        datasource='Prometheus',
        pointradius=1,
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
        formatY1='ops',
        aliasColors={
            "Cachetable Items Processed": "#614d93",
            "Cleaner Executions": "#70dbed"
          },
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_cachetable_cleaner_executions{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_cachetable_cleaner_executions{service_name="$service"}[5m])',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='Cleaner Executions',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_cachetable_pool_client_total_items_processed{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_cachetable_pool_client_total_items_processed{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Client Items Processed',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_cachetable_pool_cachetable_total_items_processed{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_cachetable_pool_cachetable_total_items_processed{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Cachetable Items Processed',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_tokudb_cachetable_pool_checkpoint_total_items_processed{service_name="$service"}[$interval]) or irate(mysql_global_status_tokudb_cachetable_pool_checkpoint_total_items_processed{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Checkpoint Items Processed',
          )
      ),
      gridPos={
          "h": 7,
          "w": 12,
          "x": 12,
          "y": 18
      }
    )//76 graph
    ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 10,
    },
    style=null,
)//73 row
.addPanel(
    row.new(
      title='Performance Schema',
      collapse=true,
    )
    .addPanel(
      graphPanel.new(
        'TokuDB Top Wait Events (Count)',//title
        fill=2,
        linewidth=2,
        decimals=2,
        lines=false,
        points=true,
        datasource='Prometheus',
        pointradius=1,
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
        formatY1='ops',
        min=0,
        aliasColors={
            "Cachetable Items Processed": "#614d93",
            "Cleaner Executions": "#70dbed"
          },
      )
      .addTarget(
          prometheus.target(
            'topk(5,rate(mysql_perf_schema_events_waits_total{service_name="$service",event_name=~".+/fti/.+|.+/tokudb/.+"}[$interval]))',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='{{event_name}}',
          )
      ),
      gridPos={
        "h": 7,
         "w": 12,
         "x": 0,
         "y": 12
      }
    )//81 graph
    .addPanel(
      graphPanel.new(
        'TokuDB Top Wait Events (Load)',//title
        fill=2,
        linewidth=2,
        decimals=2,
        lines=false,
        points=true,
        datasource='Prometheus',
        pointradius=1,
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
        aliasColors={
            "Cachetable Items Processed": "#614d93",
            "Cleaner Executions": "#70dbed"
          },
      )
      .addTarget(
          prometheus.target(
            'topk(5,rate(mysql_perf_schema_events_waits_seconds_total{service_name="$service",event_name=~".+/fti/.+|.+/tokudb/.+"}[$interval]))',
            interval='$interval',
            step=300,
            intervalFactor=1,
            legendFormat='{{event_name}}',
          )
      ),
      gridPos={
        "h": 7,
         "w": 12,
         "x": 12,
         "y": 12
      }
    )//82 graph
    ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 11,
    },
    style=null,
)//71 row
.addPanel(
    row.new(
      title='MySQL Summary',
      collapse=true,
    )
    .addPanel(
      graphPanel.new(
        'MySQL Connections and Questions',//title
        description='**Max Connections** \n\nMax Connections is the maximum permitted number of simultaneous client connections. By default, this is 151. Increasing this value increases the number of file descriptors that mysqld requires. If the required number of descriptors are not available, the server reduces the value of Max Connections.\n\nmysqld actually permits Max Connections + 1 clients to connect. The extra connection is reserved for use by accounts that have the SUPER privilege, such as root.\n\nMax Used Connections is the maximum number of connections that have been in use simultaneously since the server started.\n\nConnections is the number of connection attempts (successful or not) to the MySQL server.',
        fill=2,
        linewidth=2,
        decimals=2,
        datasource='Prometheus',
        pointradius=5,
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
        value_type='cumulative',
        formatY2='ops',
        min=0,
        links=[
            {
              "targetBlank": true,
              "title": "MySQL Server System Variables",
              "type": "absolute",
              "url": "https://dev.mysql.com/doc/refman/5.7/en/server-system-variables.html#sysvar_max_connections"
            }
          ],
        aliasColors={
            "Max Connections": "#bf1b00",
            "New Connections": "#ba43a9",
            "Questions": "#1f78c1"
          },
      )
      .addSeriesOverride({
              "alias": "Max Connections",
              "fill": 0
            })
      .addSeriesOverride({
              "alias": "Questions",
              "lines": false,
              "pointradius": 1,
              "points": true,
              "yaxis": 2
            })
      .addSeriesOverride({
              "alias": "Max Used Connections",
              "fill": 0
            })
      .addSeriesOverride({
              "alias": "New Connections",
              "lines": false,
              "pointradius": 1,
              "points": true,
              "yaxis": 2
            })
      .addTarget(
          prometheus.target(
            'max(max_over_time(mysql_global_status_threads_connected{service_name="$service"}[$interval])  or mysql_global_status_threads_connected{service_name="$service"} )',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Current Connections',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'mysql_global_status_max_used_connections{service_name="$service"}',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Max Used Connections',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'mysql_global_variables_max_connections{service_name="$service"}',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Max Connections',
            calculatedInterval='2m',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_questions{service_name="$service"}[$interval]) or irate(mysql_global_status_questions{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Questions',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(mysql_global_status_connections{service_name="$service"}[$interval]) or irate(mysql_global_status_connections{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='New Connections',
          )
      ),
      gridPos={
        "h": 7,
         "w": 12,
         "x": 0,
         "y": 13
      }
    )//91 graph
    .addPanel(
      graphPanel.new(
        'MySQL Client Thread Activity',//title
        description='**MySQL Active Threads**\n\nThreads Connected is the number of open connections, while Threads Running is the number of threads not sleeping.',
        fill=2,
        linewidth=2,
        decimals=2,
        datasource='Prometheus',
        pointradius=5,
        legend_values=true,
        legend_current=true,
        legend_min=true,
        legend_max=true,
        legend_avg=true,
        legend_alignAsTable=true,
        legend_show=true,
        legend_sortDesc=true,
        editable=true,
        labelY1='Threads',
        min=0,
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
         "y": 13
      }
    )//90 graph
    .addPanel(
      graphPanel.new(
        'Top Command Counters',//title
        description='**Top Command Counters**\n\nThe Com_{{xxx}} statement counter variables indicate the number of times each xxx statement has been executed. There is one status variable for each type of statement. For example, Com_delete and Com_update count [``DELETE``](https://dev.mysql.com/doc/refman/5.7/en/delete.html) and [``UPDATE``](https://dev.mysql.com/doc/refman/5.7/en/update.html) statements, respectively. Com_delete_multi and Com_update_multi are similar but apply to [``DELETE``](https://dev.mysql.com/doc/refman/5.7/en/delete.html) and [``UPDATE``](https://dev.mysql.com/doc/refman/5.7/en/update.html) statements that use multiple-table syntax.',
        fill=2,
        linewidth=2,
        decimals=2,
        lines=false,
        bars=true,
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
        stack=true,
        formatY1='ops',
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
            'topk(5, rate(mysql_global_status_commands_total{service_name="$service"}[$interval])>0) or topk(5, irate(mysql_global_status_commands_total{service_name="$service"}[5m])>0)',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='Com_{{ command }}',
            calculatedInterval='2m',
          )
      ),
      gridPos={
          "h": 7,
          "w": 12,
          "x": 0,
          "y": 20
      }
    )//92 graph
    .addPanel(
      graphPanel.new(
        'MySQL Row Handlers',//title
        description="**MySQL Handlers**\n\nHandler statistics are internal statistics on how MySQL is selecting, updating, inserting, and modifying rows, tables, and indexes.\n\nThis is in fact the layer between the Storage Engine and MySQL.\n\n* `read_rnd_next` is incremented when the server performs a full table scan and this is a counter you don't really want to see with a high value.\n* `read_key` is incremented when a read is done with an index.\n* `read_next` is incremented when the storage engine is asked to 'read the next index entry'. A high value means a lot of index scans are being done.",
        fill=2,
        linewidth=2,
        decimals=2,
        lines=false,
        bars=true,
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
        legend_hideZero=true,
        legend_hideEmpty=true,
        editable=true,
        stack=true,
        formatY1='ops',
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
            'rate(mysql_global_status_handlers_total{service_name="$service", handler!~"external_lock|commit|rollback|savepoint.*|prepare"}[$interval]) or irate(mysql_global_status_handlers_total{service_name="$service", handler!~"external_lock|commit|rollback|savepoint.*|prepare"}[5m])',
            interval='$interval',
            step=20,
            intervalFactor=1,
            legendFormat='{{handler}}',
            calculatedInterval='2m',
          )
      ),
      gridPos={
          "h": 7,
          "w": 12,
          "x": 12,
          "y": 20
      }
    )//94 graph
    ,gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 12,
    },
    style=null,
)//87 row
.addPanel(
    row.new(
      title='System Summary',
      collapse=true,
    )
    .addPanel(
      graphPanel.new(
        'CPU Usage',//title
        fill=5,
        linewidth=1,
        decimals=2,
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
        legend_hideZero=true,
        legend_hideEmpty=true,
        stack=true,
        editable=true,
        formatY1='percent',
        min=0,
        maxY1='100',
        aliasColors={
            "Max Core Utilization": "#bf1b00",
            "idle": "#806EB7",
            "iowait": "#E24D42",
            "nice": "#1F78C1",
            "softirq": "#806EB7",
            "system": "#EAB839",
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
      .addTarget(
          prometheus.target(
            'clamp_max(((avg by (mode) ( (clamp_max(rate(node_cpu_seconds_total{service_name="$service",mode!="idle"}[$interval]),1)) or (clamp_max(irate(node_cpu_seconds_total{service_name="$service",mode!="idle"}[5m]),1)) ))*100 or (avg_over_time(node_cpu_average{instance=~"$host", mode!="total", mode!="idle"}[$interval]) or avg_over_time(node_cpu_average{instance=~"$host", mode!="total", mode!="idle"}[5m]))),100)',
            interval='$interval',
            intervalFactor=1,
            legendFormat='{{ mode }}',
          )
      )
      .addTarget(
          prometheus.target(
            'clamp_max(max by () (sum  by (cpu) ( (clamp_max(rate(node_cpu_seconds_total{service_name="$service",mode!="idle",mode!="iowait"}[$interval]),1)) or (clamp_max(irate(node_cpu_seconds_total{service_name="$service",mode!="idle",mode!="iowait"}[5m]),1)) )),1)',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Max Core Utilization',
            hide=true,
          )
      ),
      gridPos={
        "h": 7,
         "w": 12,
         "x": 0,
         "y": 14,
      }
    )//95 graph
    .addPanel(
      graphPanel.new(
        'Saturation and Max Core Usage',//title
        fill=2,
        linewidth=2,
        decimals=2,
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
        formatY2='percentunit',
        min=0,
        maxY2='1',
        aliasColors={
            "Allocated": "#E0752D",
            "CPU Load": "#64B0C8",
            "IO Load": "#f9934e",
            "IO Load ": "#EA6460",
            "Limit": "#1F78C1",
            "Max CPU Core Utilization": "#bf1b00",
            "Max Core Usage": "#bf1b00",
            "Normalized CPU Load": "#6ED0E0"
          },
      )
      .addSeriesOverride({
              "alias": "Max CPU Core Utilization",
              "lines": false,
              "pointradius": 1,
              "points": true,
              "yaxis": 2
            })
      .addTarget(
          prometheus.target(
            '(avg_over_time(node_procs_running{service_name="$service"}[$interval])-1) / scalar(count(node_cpu_seconds_total{mode="user", service_name="$service"})) or (avg_over_time(node_procs_running{service_name="$service"}[5m])-1) / scalar(count(node_cpu_seconds_total{mode="user", service_name="$service"}))',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Normalized CPU Load',
            calculatedInterval='2s',
            step=300,
          )
      )
      .addTarget(
          prometheus.target(
            'clamp_max(max by () (sum  by (cpu) ( (clamp_max(rate(node_cpu_seconds_total{service_name="$service",mode!="idle",mode!="iowait"}[$interval]),1)) or (clamp_max(irate(node_cpu_seconds_total{service_name="$service",mode!="idle",mode!="iowait"}[5m]),1)) )),1)',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Max CPU Core Utilization',
            calculatedInterval='2s',
            step=300,
          )
      )
      .addTarget(
          prometheus.target(
            'avg_over_time(node_procs_blocked{service_name="$service"}[$interval]) or avg_over_time(node_procs_blocked{service_name="$service"}[5m])',
            interval='$interval',
            intervalFactor=1,
            legendFormat='IO Load',
          )
      ),
      gridPos={
        "h": 7,
         "w": 12,
         "x": 12,
         "y": 14,
      }
    )//96 graph
    .addPanel(
      graphPanel.new(
        'Disk I/O and Swap Activity',//title
        fill=2,
        linewidth=2,
        decimals=2,
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
        formatY1='Bps',
        labelY1='Page Out (-) / Page In (+)',
        formatY2='bytes',
        minY2=0,
        links=[
                        {
                            "dashboard": "Disk Performance",
                            "dashUri": "db/disk-performance",
                            "includeVars": true,
                            "keepTime": true,
                            "targetBlank": true,
                            "title": "Disk Performance",
                            "type": "dashboard"
                        }
                    ],
        aliasColors={
            "Swap In (Reads)": "#6ed0e0",
            "Swap Out (Writes)": "#ef843c",
            "Total": "#bf1b00"
          },
      )
      .addSeriesOverride({
              "alias": "Disk Writes (Page Out)",
              "transform": "negative-Y"
            })
      .addSeriesOverride({
              "alias": "Total",
              "legend": false,
              "lines": false
            })
      .addSeriesOverride({
              "alias": "Swap Out (Writes)",
              "transform": "negative-Y"
            })
      .addTarget(
          prometheus.target(
            'rate(node_vmstat_pgpgin{service_name="$service"}[$interval]) * 1024 or irate(node_vmstat_pgpgin{service_name="$service"}[5m]) * 1024',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Disk Reads (Page In)',
            calculatedInterval='2s',
            step=300,
          )
      )
      .addTarget(
          prometheus.target(
            '(rate(node_vmstat_pgpgout{service_name="$service"}[$interval]) * 1024 or irate(node_vmstat_pgpgout{service_name="$service"}[5m]) * 1024)',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Disk Writes (Page Out)',
            calculatedInterval='2s',
            step=300,
          )
      )
      .addTarget(
          prometheus.target(
            '(rate(node_vmstat_pgpgin{service_name="$service"}[$interval]) * 1024 or irate(node_vmstat_pgpgin{service_name="$service"}[5m]) * 1024 ) + (rate(node_vmstat_pgpgout{service_name="$service"}[$interval]) * 1024 or irate(node_vmstat_pgpgout{service_name="$service"}[5m]) * 1024)',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Total',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(node_vmstat_pswpin{service_name="$service"}[$interval]) * 4096 or irate(node_vmstat_pswpin{service_name="$service"}[5m]) * 4096',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Swap In (Reads)',
          )
      )
      .addTarget(
          prometheus.target(
            'rate(node_vmstat_pswpout{service_name="$service"}[$interval]) * 4096 or irate(node_vmstat_pswpout{service_name="$service"}[5m]) * 4096',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Swap Out (Writes)',
          )
      ),
      gridPos={
          "h": 7,
          "w": 12,
          "x": 0,
          "y": 21
      }
    )//97 graph
    .addPanel(
      graphPanel.new(
        'Network Traffic',//title
        fill=2,
        linewidth=2,
        decimals=2,
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
        formatY1='Bps',
        labelY1='Outbound (-) / Inbound (+)',
        formatY2='bytes',
        minY2=0,
      )
      .addSeriesOverride({
              "alias": "Outbound",
              "transform": "negative-Y"
            })
      .addTarget(
          prometheus.target(
            'sum(rate(node_network_receive_bytes_total{service_name="$service", device!="lo"}[$interval])) or sum(irate(node_network_receive_bytes_total{service_name="$service", device!="lo"}[5m])) or sum(max_over_time(rdsosmetrics_network_rx{service_name="$service"}[$interval])) or sum(max_over_time(rdsosmetrics_network_rx{service_name="$service"}[5m]))',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Inbound',
            calculatedInterval='2s',
            step=300,
          )
      )
      .addTarget(
          prometheus.target(
            'sum(rate(node_network_transmit_bytes_total{service_name="$service", device!="lo"}[$interval])) or sum(irate(node_network_transmit_bytes_total{service_name="$service", device!="lo"}[5m])) or
            sum(max_over_time(rdsosmetrics_network_tx{service_name="$service"}[$interval])) or sum(max_over_time(rdsosmetrics_network_tx{service_name="$service"}[5m]))',
            interval='$interval',
            intervalFactor=1,
            legendFormat='Outbound',
            calculatedInterval='2s',
            step=300,
          )
      ),
      gridPos={
          "h": 7,
          "w": 12,
          "x": 12,
          "y": 21
      }
    )//97 graph
    ,gridPos={
      "h": 1,
      "w": 24,
      "x": 0,
      "y": 13,
    },
    style=null,
)//71 row
