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
  'MySQL MyISAM/Aria Metrics',
  time_from='now-12h',
  editable=true,
  refresh= "1m",
  graphTooltip='shared_crosshair',
  schemaVersion=18,
  version=1,
  tags=["Percona","MySQL"],
  iteration=1552405161783,
  uid="q8z9QGHik",
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
  'label_values(mysql_up,node_name)',
  label='Host',
  refresh='load',
  sort=1,
  allFormat='glob',
  multiFormat='regex values',
  multi=false,
  skipUrlSync=false,
  definition='label_values(mysql_up,node_name)',
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
  includeAll=false,
  definition='label_values(mysql_up{node_name=~"$host"}, service_name)',
  ),
)
.addPanel(
    row.new(
      title='MyISAM Metrics',
    ),
    gridPos={
    "h": 1,
    "w": 24,
    "x": 0,
    "y": 0,
    },
    style=null,
)//28 row
.addPanel(
  graphPanel.new(
    'MyISAM Indexes',//title
    fill=2,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    height='250px',
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
    min=0,
    format='short',
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
        'rate(mysql_global_status_key_reads{service_name="$service"}[$interval]) or irate(mysql_global_status_key_reads{service_name="$service"}[5m])',
        refId='D',
        interval='$interval',
        calculatedInterval='2m',
        step=20,
        intervalFactor=1,
        legendFormat='Key Reads',
      )
  )
  .addTarget(
      prometheus.target(
        'rate(mysql_global_status_key_read_requests{service_name="$service"}[$interval]) or irate(mysql_global_status_key_read_requests{service_name="$service"}[5m])',
        refId='A',
        interval='$interval',
        calculatedInterval='2m',
        step=20,
        intervalFactor=1,
        legendFormat='Key Read Requests',
      )
  )
  .addTarget(
      prometheus.target(
        'rate(mysql_global_status_key_writes{service_name="$service"}[$interval]) or irate(mysql_global_status_key_writes{service_name="$service"}[5m])',
        refId='B',
        interval='$interval',
        calculatedInterval='2m',
        step=20,
        intervalFactor=1,
        legendFormat='Key Writes',
      )
  )
  .addTarget(
      prometheus.target(
        'rate(mysql_global_status_key_write_requests{service_name="$service"}[$interval]) or irate(mysql_global_status_key_write_requests{service_name="$service"}[5m])',
        refId='C',
        interval='$interval',
        calculatedInterval='2m',
        step=20,
        intervalFactor=1,
        legendFormat='Key Write Requests',
      )
  ),
  gridPos={
    "h": 7,
    "w": 24,
    "x": 0,
    "y": 1,
  },
  style=null,
)//3 graph
.addPanel(
  graphPanel.new(
    'MyISAM Key Buffer Performance',//title
    description='The `Key Read Ratio`  (Key_reads/Key_read_requests) ratio should normally be less than 0.01.

    The  `Key Write Ratio` (Key_writes/Key_write_requests) ratio is usually near 1 if you are using mostly updates and deletes, but might be much smaller if you tend to do updates that affect many rows at the same time or if you are using the `DELAY_KEY_WRITE` table option.',
    fill=2,
    linewidth=2,
    decimals=2,
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
    legend_sortDesc=true,
    legend_sort='avg',
    editable=true,
    min=0,
    format='short',
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
        'rate(mysql_global_status_key_reads{service_name="$service"}[$interval]) / rate(mysql_global_status_key_read_requests{service_name="$service"}[$interval]) or irate(mysql_global_status_key_reads{service_name="$service"}[5m]) / irate(mysql_global_status_key_read_requests{service_name="$service"}[5m])',
        refId='D',
        interval='$interval',
        calculatedInterval='2m',
        step=20,
        intervalFactor=1,
        legendFormat='Key Read Ratio',
      )
  )
  .addTarget(
      prometheus.target(
        'rate(mysql_global_status_key_writes{service_name="$service"}[$interval]) / rate(mysql_global_status_key_write_requests{service_name="$service"}[$interval]) or irate(mysql_global_status_key_writes{service_name="$service"}[5m]) / irate(mysql_global_status_key_write_requests{service_name="$service"}[5m])',
        refId='A',
        interval='$interval',
        calculatedInterval='2m',
        step=20,
        intervalFactor=1,
        legendFormat='Key Write Ratio',
      )
  ),
  gridPos={
     "h": 7,
     "w": 12,
     "x": 0,
     "y": 8,
     },
  style=null,
)//22 graph
.addPanel(
  graphPanel.new(
    'MyISAM Key Cache',//title
    fill=6,
    linewidth=2,
    decimals=2,
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
    legend_sortDesc=true,
    legend_sort='avg',
    editable=true,
    min=0,
    format='short',
  )
  .addSeriesOverride(
      {
        "alias": "Key Blocks Not Flushed",
        "fill": 0
      }
  )
  .addTarget(
      prometheus.target(
        'mysql_global_variables_key_buffer_size{service_name="$service"}',
        refId='C',
        interval='$interval',
        calculatedInterval='2m',
        step=20,
        intervalFactor=1,
        legendFormat='Key Buffer Size',
      )
  )
  .addTarget(
      prometheus.target(
        'mysql_global_variables_key_buffer_size{service_name="$service"} - mysql_global_status_key_blocks_unused{service_name="$service"} * mysql_global_variables_key_cache_block_size{service_name="$service"}',
        refId='B',
        interval='$interval',
        calculatedInterval='2m',
        step=20,
        intervalFactor=1,
        legendFormat='Key Blocks Used',
      )
  )
  .addTarget(
      prometheus.target(
        'mysql_global_status_key_blocks_not_flushed{service_name="$service"} * mysql_global_variables_key_cache_block_size{service_name="$service"}',
        refId='A',
        interval='$interval',
        calculatedInterval='2m',
        step=20,
        intervalFactor=1,
        legendFormat='Key Blocks Not Flushed',
      )
  ),
  gridPos={
     "h": 7,
     "w": 12,
     "x": 12,
     "y": 8,
     },
  style=null,
)//21 graph
.addPanel(
    row.new(
      title='Aria Metrics',
    ),
    gridPos={
       "h": 1,
       "w": 24,
       "x": 0,
       "y": 15,
    },
    style=null,
)//29 row
.addPanel(
  graphPanel.new(
    'Aria Pagecache Reads/Writes',//title
    description='This graph is similar to InnoDB buffer pool reads/writes. `aria-pagecache-buffer-size` is the main cache for the Aria storage engine. If you see high reads/writes (physical IO), i.e. reads are close to read requests and/or writes are close to write requests you may need to increase the `aria-pagecache-buffer-size` (may need to decrease other buffers: `key_buffer_size`, `innodb_buffer_pool_size`, etc.)',
    fill=2,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    height='250px',
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
    min=0,
    format='short',
  )
  .addTarget(
      prometheus.target(
        'rate(mysql_global_status_aria_pagecache_write_requests{service_name="$service"}[$interval]) or irate(mysql_global_status_aria_pagecache_write_requests{service_name="$service"}[5m])',
        refId='D',
        interval='$interval',
        calculatedInterval='2m',
        step=20,
        intervalFactor=1,
        legendFormat='Aria Pagecache Write Requests',
      )
  )
  .addTarget(
      prometheus.target(
        'rate(mysql_global_status_aria_pagecache_read_requests{service_name="$service"}[$interval]) or irate(mysql_global_status_aria_pagecache_read_requests{service_name="$service"}[5m])',
        refId='C',
        interval='$interval',
        calculatedInterval='2m',
        step=20,
        intervalFactor=1,
        legendFormat='Aria Pagecache Read Requests',
      )
  )
  .addTarget(
      prometheus.target(
        'rate(mysql_global_status_aria_pagecache_reads{service_name="$service"}[$interval]) or irate(mysql_global_status_aria_pagecache_reads{service_name="$service"}[5m])',
        refId='A',
        interval='$interval',
        calculatedInterval='2m',
        step=20,
        intervalFactor=1,
        legendFormat='Aria Pagecache Reads',
      )
  )
  .addTarget(
      prometheus.target(
        'rate(mysql_global_status_aria_pagecache_writes{service_name="$service"}[$interval]) or irate(mysql_global_status_aria_pagecache_writes{service_name="$service"}[5m])',
        refId='B',
        interval='$interval',
        calculatedInterval='2m',
        step=20,
        intervalFactor=1,
        legendFormat='Aria Pagecache Writes',
      )
  ),
  gridPos={
    "h": 7,
    "w": 18,
    "x": 0,
    "y": 16,
     },
  style=null,
)//24 graph
.addPanel(
  text.new(
    title='Aria Storage Engine',
    content='The Aria Storage Engine ships only with MariaDB so you should expect to see empty Aria graphs if you are running Percona Server for MySQL, MySQL Community, or MySQL Enterprise.',
    description='The Aria storage is specific to MariaDB Server. Aria has most of the same variables that MyISAM has, but with an Aria prefix. If you use Aria instead of MyISAM, then you should make key-buffer-size smaller and aria-pagecache-buffer-size bigger.',
    datasource='Prometheus',
    height='250px',
    mode='markdown',
    links=[
        {
          "targetBlank": true,
          "title": "Optimize Aria: MariaDB Documentation",
          "type": "absolute",
          "url": "https://mariadb.com/kb/en/the-mariadb-library/optimize-aria/"
        }
      ]
  ),
  gridPos={
    "h": 7,
    "w": 6,
    "x": 18,
    "y": 16,
      },
  style=null,
)//27 text
.addPanel(
  graphPanel.new(
    'Aria Transaction Log Syncs',//title
    description='This is similar to InnoDB log file syncs. If you see lots of log syncs and want to relax the durability settings you can change `aria_checkpoint_interval` (in seconds) from 30 (default) to a higher number. It is good to look at the disk IO dashboard as well.',
    fill=1,
    linewidth=1,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    height='250px',
    legend_values=false,
    legend_min=false,
    legend_max=false,
    legend_avg=false,
    legend_show=true,
    editable=true,
    minY1='0',
    format='short',
    links=[
        {
          "targetBlank": true,
          "title": "Aria System Variables: MariaDB Documentation",
          "type": "absolute",
          "url": "https://mariadb.com/kb/en/library/aria-system-variables/"
        }
      ],
  )
  .addTarget(
      prometheus.target(
        'rate(mysql_global_status_aria_transaction_log_syncs{service_name="$service"}[$interval]) or irate(mysql_global_status_aria_transaction_log_syncs{service_name="$service"}[5m])',
        refId='A',
        step=5,
        intervalFactor=1,
        legendFormat='Aria Transaction Log Syncs',
      )
  ),
  gridPos={
         "h": 7,
         "w": 12,
         "x": 0,
         "y": 23,
     },
  style=null,
)//26 graph
.addPanel(
  graphPanel.new(
    'Aria Pagecache Blocks',//title
    description='This graph shows the utilization for the Aria pagecache. This is similar to InnDB buffer pool graph. If you see all blocks are used you may consider increasing `aria-pagecache-buffer-size` (may need to decrease other buffers: `key_buffer_size`, `innodb_buffer_pool_size`, etc.)',
    fill=2,
    linewidth=2,
    datasource='Prometheus',
    pointradius=10,
    paceLength=10,
    decimals=0,
    height='250px',
    legend_values=true,
    legend_min=false,
    legend_max=false,
    legend_avg=false,
    legend_current=true,
    legend_alignAsTable=true,
    legend_show=true,
    legend_sortDesc=true,
    legend_sort='avg',
    editable=true,
    min='0',
    maxY2='100',
    formatY1='none',
    sort='decreasing',
    shared_tooltip=false,
  )
  .addSeriesOverride(
    {
      "alias": "Aria Pagecache Total Blocks",
      "fill": 0
    }
  )
  .addTarget(
      prometheus.target(
        'mysql_global_status_aria_pagecache_blocks_not_flushed{service_name="$service"}',
        refId='D',
        step=20,
        interval='$interval',
        intervalFactor=1,
        legendFormat='Aria Pagecache Blocks Not Flushed',
        calculatedInterval='2m',
      )
  )
  .addTarget(
      prometheus.target(
        'mysql_global_status_aria_pagecache_blocks_used{service_name="$service"}',
        refId='A',
        step=20,
        interval='$interval',
        intervalFactor=1,
        legendFormat='Aria Pagecache Blocks Used',
        calculatedInterval='2m',
      )
  )
  .addTarget(
      prometheus.target(
        'mysql_global_status_aria_pagecache_blocks_unused{service_name="$service"}',
        refId='C',
        step=5,
        interval='',
        intervalFactor=1,
        legendFormat='Aria Pagecache Blocks Unused',
        calculatedInterval='2m',
      )
  )
  .addTarget(
      prometheus.target(
        'mysql_global_variables_aria_pagecache_buffer_size{service_name="$service"} / mysql_global_variables_aria_block_size{service_name="$service"}',
        refId='B',
        step=5,
        interval='$interval',
        intervalFactor=1,
        legendFormat='Aria Pagecache Total Blocks',
      )
  ),
  gridPos={
         "h": 7,
         "w": 12,
         "x": 12,
         "y": 23,
     },
  style=null,
)//25 graph
