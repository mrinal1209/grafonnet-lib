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
  'MySQL InnoDB Compression',
  time_from='now-12h',
  editable=false,
  refresh= "5m",
  graphTooltip='shared_crosshair',
  schemaVersion=18,
  version=5,
  tags=['MySQL','Percona'],
  iteration=1552404172906,
  uid="CnOxqWGmz",
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
  allFormat='glob',
  multiFormat='regex values',
  multi=false,
  skipUrlSync=false,
  definition='label_values(mysql_up, node_name)',
  includeAll=false,
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
  ),
)
.addTemplate(
  template.new(
  'buffer',
  'Prometheus',
  'label_values(mysql_info_schema_innodb_cmpmem_pages_used_total,buffer)',
  refresh='load',
  sort=1,
  multi=true,
  skipUrlSync=false,
  definition='',
  includeAll=true,
  allValues='blank = All',
  hide=2,
  regex='/./',
  ),
)
.addPanel(
    row.new(
      title='Compression level and failure rate threshold',
    ),
    gridPos={
    "h": 1,
    "w": 24,
    "x": 0,
    "y": 0,
    },
    style=null,
)//76 row
.addPanel(
  singlestat.new(
    'InnoDB Compression level',//title
    description='The level of zlib compression to use for InnoDB compressed tables and indexes.',
    format='none',
    datasource='Prometheus',
    valueName='current',
    thresholds='',
    colors=[
        "#447ebc",
        "#447ebc",
        "#447ebc",
        ],
    height='125px',
    maxPerRow=4,
    gaugeThresholdLabels=true,
    gaugeMaxValue=10,
  )
  .addTarget(
    prometheus.target(
      'mysql_global_variables_innodb_compression_level{service_name="$service"}',
      intervalFactor = 1,
    )
  ),
  gridPos = {
        "h": 3,
        "w": 6,
        "x": 0,
        "y": 1,
        },
  style=null,
)//51 singlestat
.addPanel(
  singlestat.new(
    'InnoDB Compression Failure Threshold',//title
    description='The compression failure rate threshold for a table',
    format='percent',
    datasource='Prometheus',
    valueName='current',
    thresholds='',
    colors=[
      "#1f78c1",
      "#1f78c1",
      "#1f78c1",
        ],
    height='125px',
    maxPerRow=4,
    gaugeThresholdLabels=true,
    valueMaps=[
        {
          "op": "=",
          "text": "N/A",
          "value": "null"
        },
        {
          "op": "=",
          "text": "Enabled",
          "value": "1"
        },
        {
          "op": "=",
          "text": "Disabled",
          "value": "0"
        }
      ],
  )
  .addTarget(
    prometheus.target(
      'mysql_global_variables_innodb_compression_failure_threshold_pct{service_name="$service"}',
      intervalFactor = 1,
      interval='$interval',
    )
  ),
  gridPos = {
        "h": 3,
        "w": 6,
        "x": 6,
        "y": 1,
        },
  style=null,
)//57 singlestat
.addPanel(
  singlestat.new(
    'Compression Failure Rate Threshold',//title
    description='The maximum percentage that can be reserved as free space within each compressed page, allowing room to reorganize the data and modification log within the page when a compressed table or index is updated and the data might be recompressed.',
    format='percent',
    datasource='Prometheus',
    valueName='current',
    thresholds='',
    colors=[
      "#447ebc",
      "#447ebc",
      "#447ebc",
        ],
    height='125px',
    maxPerRow=4,
    gaugeThresholdLabels=true,
    gaugeMaxValue=75,
  )
  .addTarget(
    prometheus.target(
      'mysql_global_variables_innodb_compression_pad_pct_max{service_name="$service"}',
    )
  ),
  gridPos = {
        "h": 3,
        "w": 6,
        "x": 12,
        "y": 1,
        },
  style=null,
)//52 singlestat
.addPanel(
  singlestat.new(
    'Write Pages to The Redo Log',//title
    description='Specifies whether images of re-compressed pages are written to the redo log. Re-compression may occur when changes are made to compressed data.',
    format='none',
    datasource='Prometheus',
    thresholds='',
    colors=[
      "#299c46",
              "rgba(237, 129, 40, 0.89)",
              "#d44a3a",
        ],
    height='125px',
    maxPerRow=4,
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
      'mysql_global_variables_innodb_log_compressed_pages{service_name="$service"}',
      intervalFactor = 1,
      interval='$interval',
    )
  ),
  gridPos = {
        "h": 3,
        "w": 6,
        "x": 18,
        "y": 1,
        },
  style=null,
)//69 singlestat
.addPanel(
    row.new(
      title='Statistic of compression operations',
    ),
    gridPos={
      "h": 1,
      "w": 24,
      "x": 0,
      "y": 4,
    },
    style=null,
)//77 row
.addPanel(
  graphPanel.new(
    'Compress Attempts',//title
    description='Number of compression operations attempted. Pages are compressed whenever an empty page is created or the space for the uncompressed modification log runs out.',
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
    legend_rightSide=false,
    legend_show=true,
    legend_sortDesc=true,
    legend_sort='avg',
    editable=true,
    maxPerRow=2,
    formatY1='ops',
    formatY2='bytes',
    min=0,
    aliasColors={
        "Max Checkpoint Age": "#BF1B00",
        "Uncheckpointed Bytes": "#E0752D"
      },
  )
  .addTarget(
      prometheus.target(
        'rate(mysql_info_schema_innodb_cmp_compress_ops_total{service_name="$service"}[$interval]) or irate(mysql_info_schema_innodb_cmp_compress_ops_total{service_name="$service"}[5m])',
        interval='$interval',
        calculatedInterval='2m',
        step=300,
        intervalFactor=1,
        legendFormat='{{ page_size }}',
      )
  ),
  gridPos={
        "h": 7,
        "w": 12,
        "x": 0,
        "y": 5,
        },
  style=null,
)//19 graph
.addPanel(
  graphPanel.new(
    'Uncompressed Attempts',//title
    description='Number of uncompression operations performed. Compressed InnoDB pages are uncompressed whenever compression fails, or the first time a compressed page is accessed in the buffer pool and the uncompressed page does not exist.',
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
    legend_rightSide=false,
    legend_show=true,
    legend_sortDesc=true,
    legend_sort='avg',
    editable=true,
    maxPerRow=2,
    formatY1='ops',
    min=0,
  )
  .addSeriesOverride(
      {
          "alias": "InnoDB Transactions",
          "yaxis": 2
        }
  )
  .addTarget(
      prometheus.target(
        'rate(mysql_info_schema_innodb_cmp_uncompress_ops_total{service_name="$service"}[$interval]) or
        irate(mysql_info_schema_innodb_cmp_uncompress_ops_total{service_name="$service"}[5m])',
        interval='$interval',
        calculatedInterval='2m',
        step=300,
        intervalFactor=1,
        legendFormat='{{ page_size }}',
      )
  ),
  gridPos={
        "h": 7,
        "w": 12,
        "x": 12,
        "y": 5,
        },
  style=null,
)//20 graph
.addPanel(
  graphPanel.new(
    'Compression Success Ratio',//title
    description='Shows the ratio between Success InnoDB Compress vs the total InnoDB Compress operations. A high ration indicates that InnoDB compression is being effective and helping to save disk space.\n\nSee also:',
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
    legend_rightSide=true,
    legend_show=true,
    legend_sortDesc=true,
    legend_sort='avg',
    editable=true,
    maxPerRow=1,
    formatY1='percentunit',
    min=0,
    links=[
        {
          "targetBlank": true,
          "title": "Using the Compression Information Schema Tables",
          "type": "absolute",
          "url": "https://dev.mysql.com/doc/refman/5.7/en/innodb-information-schema-examples-compression-sect.html"
        }
      ],
  )
  .addTarget(
      prometheus.target(
        'sum_over_time(mysql_info_schema_innodb_cmp_compress_ops_ok_total{service_name="$service"}[$interval])/
        sum_over_time(mysql_info_schema_innodb_cmp_compress_ops_total{service_name="$service"}[$interval]) or
        sum_over_time(mysql_info_schema_innodb_cmp_compress_ops_ok_total{service_name="$service"}[5m])/
        sum_over_time(mysql_info_schema_innodb_cmp_compress_ops_total{service_name="$service"}[5m])',
        interval='$interval',
        calculatedInterval='2m',
        step=300,
        intervalFactor=1,
        legendFormat='{{ page_size }}',
      )
  ),
  gridPos={
    "h": 7,
    "w": 24,
    "x": 0,
    "y": 12,
        },
  style=null,
)//23 graph
.addPanel(
    row.new(
      title='CPU Core Usage',
    ),
    gridPos={
      "h": 1,
      "w": 24,
      "x": 0,
      "y": 19,
    },
    style=null,
)//78 row
.addPanel(
  graphPanel.new(
    'CPU Core Usage for Compression',//title
    description='Shows the time in seconds spent by InnoDB Compression operations.\n\nSee also:',
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
    legend_rightSide=false,
    legend_show=true,
    editable=true,
    maxPerRow=2,
    formatY1='percent',
    decimalsY1=0,
    timeFrom='24h',
    stack=true,
    links=[
        {
          "targetBlank": true,
          "title": "Using the Compression Information Schema Tables",
          "type": "absolute",
          "url": "https://dev.mysql.com/doc/refman/5.7/en/innodb-information-schema-examples-compression-sect.html"
        }
      ],
  )
  .addSeriesOverride(
    {
      "alias": "/.*/",
      "color": "#1f78c1"
    }
  )
  .addTarget(
      prometheus.target(
        '(sum(rate(mysql_info_schema_innodb_cmp_compress_time_seconds_total{instance=~"$host"}[$interval])) by (instance) or
        sum(irate(mysql_info_schema_innodb_cmp_compress_time_seconds_total{instance=~"$host"}[5m])) by (instance)) /
        count(node_cpu_seconds_total{mode="user", instance=~"$host"}) by (instance) *100',
        interval='1h',
        intervalFactor=1,
        legendFormat='{{instance}}',
      )
  ),
  gridPos={
        "h": 7,
        "w": 12,
        "x": 0,
        "y": 20,
        },
  style=null,
)//58 graph
.addPanel(
  graphPanel.new(
    'CPU Core Usage for Uncompression',//title
    description='Shows the time in seconds spent by InnoDB Uncompression operations.\n\nSee also:',
    fill=2,
    linewidth=2,
    decimals=2,
    bars=true,
    lines=false,
    datasource='Prometheus',
    pointradius=2,
    paceLength=10,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_rightSide=false,
    legend_show=true,
    editable=true,
    maxPerRow=2,
    formatY1='percent',
    decimalsY1=0,
    stack=true,
    timeFrom='24h',
    links=[
        {
          "targetBlank": true,
          "title": "Using the Compression Information Schema Tables",
          "type": "absolute",
          "url": "https://dev.mysql.com/doc/refman/5.7/en/innodb-information-schema-examples-compression-sect.html"
        }
      ],
  )
  .addSeriesOverride(
    {
       "alias": "/.*/",
       "color": "#1f78c1"
     }
  )
  .addTarget(
      prometheus.target(
        '(sum(rate(mysql_info_schema_innodb_cmp_uncompress_time_seconds_total{instance=~"$host"}[$interval])) by (instance) or
        sum(irate(mysql_info_schema_innodb_cmp_uncompress_time_seconds_total{instance=~"$host"}[5m])) by (instance)) /
        count(node_cpu_seconds_total{mode="user", instance=~"$host"}) by (instance) * 100',
        interval='1h',
        intervalFactor=1,
        legendFormat='{{instance}}',
      )
  ),
  gridPos={
        "h": 7,
        "w": 12,
        "x": 12,
        "y": 20,
        },
  style=null,
)//59 graph
.addPanel(
    row.new(
      title='Buffer Pool Total',
    ),
    gridPos={
      "h": 1,
      "w": 24,
      "x": 0,
      "y": 27,
    },
    style=null,
)//79 row
.addPanel(
  graphPanel.new(
    'Total Used Pages',//title
    description='Shows the total amount of used compressed pages into the InnoDB Buffer Pool split by page size.\n\nSee also:',
    fill=1,
    linewidth=1,
    decimals=0,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    legend_values=true,
    legend_min=false,
    legend_max=true,
    legend_avg=false,
    legend_current=true,
    legend_alignAsTable=true,
    legend_rightSide=false,
    legend_show=true,
    editable=true,
    links=[
        {
          "targetBlank": true,
          "title": "Using the Compression Information Schema Tables",
          "type": "absolute",
          "url": "https://dev.mysql.com/doc/refman/5.7/en/innodb-information-schema-examples-compression-sect.html"
        }
      ],
  )
  .addTarget(
      prometheus.target(
        'sum by(page_size) (mysql_info_schema_innodb_cmpmem_pages_used_total{service_name="$service"})',
        interval='$interval',
        intervalFactor=1,
        legendFormat='{{page_size}}',
      )
  ),
  gridPos={
    "h": 7,
   "w": 12,
   "x": 0,
   "y": 28,
        },
  style=null,
)//74 graph
.addPanel(
  graphPanel.new(
    'Total Free Pages',//title
    description='Shows the total amount of free compressed pages into the InnoDB Buffer Pool split by page size.\n\nSee also:',
    fill=1,
    linewidth=1,
    decimals=0,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    legend_values=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    legend_alignAsTable=true,
    legend_rightSide=false,
    legend_show=true,
    editable=true,
    maxPerRow=2,
    decimalsY1=0,
    links=[
        {
          "targetBlank": true,
          "title": "Using the Compression Information Schema Tables",
          "type": "absolute",
          "url": "https://dev.mysql.com/doc/refman/5.7/en/innodb-information-schema-examples-compression-sect.html"
        }
      ],
  )
  .addTarget(
      prometheus.target(
        'sum by(page_size) (mysql_info_schema_innodb_cmpmem_pages_free_total{service_name="$service"})',
        interval='$interval',
        intervalFactor=1,
        legendFormat='{{page_size}}',
      )
  ),
  gridPos={
        "h": 7,
        "w": 12,
        "x": 12,
        "y": 28,
        },
  style=null,
)//75 graph
.addPanel(
    row.new(
      title='Buffer Pool  $buffer',
      collapse=true,
      repeat='buffer',
    )
    .addPanel(
      graphPanel.new(
        'Used Pages (Buffer Pull $buffer)',//title
        description='Shows the amount of used compressed pages into this InnoDB Buffer Pool instance split by page size.\n\nSee also:',
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
        legend_rightSide=false,
        legend_show=true,
        editable=true,
        maxPerRow=2,
        links=[
            {
              "targetBlank": true,
              "title": "Using the Compression Information Schema Tables",
              "type": "absolute",
              "url": "https://dev.mysql.com/doc/refman/5.7/en/innodb-information-schema-examples-compression-sect.html"
            }
          ],
      )
      .addTarget(
          prometheus.target(
            'mysql_info_schema_innodb_cmpmem_pages_used_total{service_name="$service",buffer=~"$buffer"}',
            interval='$interval',
            intervalFactor=1,
            legendFormat='{{page_size}}',
          )
      ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 0,
        "y": 37 ,
            }
    )//60 graph
    .addPanel(
      graphPanel.new(
        'Pages Free (Buffer Pull $buffer)',//title
        description='Shows the amount of free compressed pages into this InnoDB Buffer Pool instance split by page size.\n\nSee also:',
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
        legend_rightSide=false,
        legend_show=true,
        editable=true,
        maxPerRow=2,
        links=[
            {
              "targetBlank": true,
              "title": "Using the Compression Information Schema Tables",
              "type": "absolute",
              "url": "https://dev.mysql.com/doc/refman/5.7/en/innodb-information-schema-examples-compression-sect.html"
            }
          ],
      )
      .addTarget(
          prometheus.target(
            'mysql_info_schema_innodb_cmpmem_pages_free_total{service_name="$service",buffer="$buffer"}',
            interval='$interval',
            intervalFactor=1,
            legendFormat='{{page_size}}',
          )
      ),
      gridPos={
        "h": 7,
        "w": 12,
        "x": 12,
        "y": 37 ,
            }
    )//62 graph
    ,gridPos={
      "h": 1,
      "w": 24,
      "x": 0,
      "y": 35,
    },
    style=null,
)//80 row
