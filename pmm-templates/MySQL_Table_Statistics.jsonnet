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
  'MySQL Table Statistics',
  time_from='now-12h',
  editable=true,
  refresh= "1m",
  graphTooltip='shared_crosshair',
  schemaVersion=18,
  version=3,
  tags=["Percona","MySQL"],
  iteration=1557129989487,
  uid="CiMg9oiik",
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
  multi=true,
  skipUrlSync=false,
  includeAll=true,
  definition='label_values(mysql_up{node_name=~"$host"}, service_name)',
  ),
)
.addPanel(
    row.new(
      title='Largest Tables',
    ),
    gridPos={
      "h": 1,
      "w": 24,
      "x": 0,
      "y": 0,
    },
    style=null,
)//55 row
.addPanel(
  tablePanel.new(
    title='Largest Tables by Row Count',
    datasource='Prometheus',
    fontSize='100%',
    scroll=false,
    showHeader=true,
    sort={
      "col":1,
      "desc":true,
      },
  )
  .addStyle(
    {
        "alias": "",
        "colorMode": null,
        "colors": [
          "rgba(245, 54, 54, 0.9)",
          "rgba(237, 129, 40, 0.89)",
          "rgba(50, 172, 45, 0.97)"
        ],
        "dateFormat": "YYYY-MM-DD HH:mm:ss",
        "decimals": 2,
        "mappingType": 1,
        "pattern": "Time",
        "thresholds": [],
        "type": "date",
        "unit": "short"
      }
  )
  .addStyle(
    {
      "colorMode": null,
      "colors": [
        "rgba(245, 54, 54, 0.9)",
        "rgba(237, 129, 40, 0.89)",
        "rgba(50, 172, 45, 0.97)"
      ],
      "dateFormat": "YYYY-MM-DD HH:mm:ss",
      "decimals": null,
      "pattern": "/.*/",
      "thresholds": [],
      "type": "number",
      "unit": "short"
    }
  )
  .addTarget(
    prometheus.target(
      'topk(10, sum(mysql_info_schema_table_rows{service_name=~"$service"}) by (schema, table)) > 0',
      intervalFactor = 1,
      refId='A',
      interval='5m',
      format='table',
      legendFormat='{{ schema }}.{{ table }}',
      step=300,
   )
   ),
  gridPos={
   "h": 7,
   "w": 12,
   "x": 0,
   "y": 1,
    },
    style=null,
)//49 table
.addPanel(
  tablePanel.new(
    title='Largest Tables by Size',
    datasource='Prometheus',
    fontSize='100%',
    scroll=false,
    showHeader=true,
    columns=[
        {
          "text": "Current",
          "value": "current"
        }
      ],
    sort={
      "col":1,
      "desc":true,
      },
  )
  .addStyle(
    {
        "alias": "",
        "colorMode": null,
        "colors": [
          "rgba(245, 54, 54, 0.9)",
          "rgba(237, 129, 40, 0.89)",
          "rgba(50, 172, 45, 0.97)"
        ],
        "dateFormat": "YYYY-MM-DD HH:mm:ss",
        "decimals": 2,
        "mappingType": 1,
        "pattern": "Time",
        "thresholds": [],
        "type": "date",
        "unit": "short"
      }
  )
  .addStyle(
    {
      "colorMode": null,
      "colors": [
        "rgba(245, 54, 54, 0.9)",
        "rgba(237, 129, 40, 0.89)",
        "rgba(50, 172, 45, 0.97)"
      ],
      "dateFormat": "YYYY-MM-DD HH:mm:ss",
      "decimals": null,
      "pattern": "/.*/",
      "thresholds": [],
      "type": "number",
      "unit": "bytes"
    }
  )
  .addTarget(
    prometheus.target(
      'topk(10, sum(mysql_info_schema_table_size{service_name=~"$service", component!="data_free"}) by (schema, table)) > 0',
      intervalFactor = 1,
      refId='A',
      interval='5m',
      format='table',
      legendFormat='{{ schema }}.{{ table }}',
      step=300,
   )
   ),
  gridPos={
        "h": 7,
        "w": 12,
        "x": 12,
        "y": 1,
    },
    style=null,
)//51 table
.addPanel(
    row.new(
      title='Pie',
    ),
    gridPos={
      "h": 1,
      "w": 24,
      "x": 0,
      "y": 8,
    },
    style=null,
)//56 row
.addPanel(
  graphPanel.new(
    'Total Database Size',//title
    fill=2,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    legend_values=false,
    legend_min=false,
    legend_max=false,
    legend_avg=false,
    legend_alignAsTable=false,
    legend_show=true,
    editable=true,
    min=0,
    formatY1='bytes',
    aliasColors={
        "Data + Index Size": "#65C5DB"
      },
  )
  .addTarget(
      prometheus.target(
        'sum(mysql_info_schema_table_size{service_name=~"$service", component!="data_free"})',
        refId='A',
        interval='$interval',
        calculatedInterval='2m',
        step=300,
        intervalFactor=1,
        legendFormat='Data + Index Size',
      )
  )
  .addTarget(
      prometheus.target(
        'sum(mysql_info_schema_table_size{service_name=~"$service", component="data_free"})',
        refId='B',
        interval='$interval',
        calculatedInterval='2m',
        step=300,
        intervalFactor=1,
        legendFormat='Freeable Size',
      )
  ),
  gridPos={
      "h": 7,
      "w": 12,
      "x": 0,
      "y": 9,
  },
  style=null,
)//54 graph
.addPanel(
  tablePanel.new(
    title='Most Fragmented Tables by Freeable Size',
    datasource='Prometheus',
    fontSize='100%',
    scroll=false,
    showHeader=true,
    columns=[
        {
          "text": "Current",
          "value": "current"
        }
      ],
    sort={
      "col":1,
      "desc":true,
      },
  )
  .addStyle(
    {
        "alias": "",
        "colorMode": null,
        "colors": [
          "rgba(245, 54, 54, 0.9)",
          "rgba(237, 129, 40, 0.89)",
          "rgba(50, 172, 45, 0.97)"
        ],
        "dateFormat": "YYYY-MM-DD HH:mm:ss",
        "decimals": 2,
        "mappingType": 1,
        "pattern": "Time",
        "thresholds": [],
        "type": "date",
        "unit": "short"
      }
  )
  .addStyle(
    {
      "colorMode": null,
      "colors": [
        "rgba(245, 54, 54, 0.9)",
        "rgba(237, 129, 40, 0.89)",
        "rgba(50, 172, 45, 0.97)"
      ],
      "dateFormat": "YYYY-MM-DD HH:mm:ss",
      "decimals": null,
      "pattern": "/.*/",
      "thresholds": [],
      "type": "number",
      "unit": "bytes"
    }
  )
  .addTarget(
    prometheus.target(
      'topk(5, sum(mysql_info_schema_table_size{service_name=~"$service", component="data_free"}) by (schema, table)) > 0',
      intervalFactor = 1,
      refId='A',
      interval='5m',
      format='table',
      legendFormat='{{ schema }}.{{ table }}',
      step=300,
   )
   ),
  gridPos={
        "h": 7,
        "w": 12,
        "x": 12,
        "y": 9,
    },
    style=null,
)//50 table
.addPanel(
    row.new(
      title='Table Activity',
    ),
    gridPos={
      "h": 1,
      "w": 24,
      "x": 0,
      "y": 16,
    },
    style=null,
)//57 row
.addPanel(
  text.new(
    content='The next two graphs are available only for [Percona Server](https://www.percona.com/doc/percona-server/5.6/diagnostics/user_stats.html) and [MariaDB](https://mariadb.com/kb/en/mariadb/user-statistics/) and require `userstat` variable turned on.',
    datasource='Prometheus',
    height='50px',
    mode='markdown',
    transparent=true,
  ),
  gridPos={
    "h": 3,
    "w": 24,
    "x": 0,
    "y": 17,
  },
  style=null,
)//44 text
.addPanel(
    row.new(
      title='Rows read',
    ),
    gridPos={
      "h": 1,
      "w": 24,
      "x": 0,
      "y": 20,
    },
    style=null,
)//58 row
.addPanel(
  graphPanel.new(
    'Top Tables by Rows Read',//title
    fill=2,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    legend_values=true,
    legend_min=false,
    legend_max=false,
    legend_avg=true,
    legend_hideEmpty=false,
    legend_alignAsTable=true,
    legend_rightSide=true,
    legend_show=true,
    legend_sortDesc=true,
    legend_sort='avg',
    editable=true,
    min=0,
  )
  .addTarget(
      prometheus.target(
        'topk(5, rate(mysql_info_schema_table_statistics_rows_read_total{service_name=~"$service"}[$interval]))or
        topk(5, irate(mysql_info_schema_table_statistics_rows_read_total{service_name=~"$service"}[5m])>0)',
        refId='A',
        interval='$interval',
        calculatedInterval='2m',
        step=300,
        intervalFactor=1,
        legendFormat='{{ schema }}.{{ table }}',
      )
  ),
  gridPos={
    "h": 7,
    "w": 24,
    "x": 0,
    "y": 21,
  },
  style=null,
)//48 graph
.addPanel(
    row.new(
      title='Rows Changed',
    ),
    gridPos={
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 28
    },
    style=null,
)//59 row
.addPanel(
  graphPanel.new(
    'Top Tables by Rows Changed',//title
    fill=2,
    linewidth=2,
    decimals=2,
    datasource='Prometheus',
    pointradius=5,
    paceLength=10,
    legend_values=true,
    legend_min=false,
    legend_max=false,
    legend_avg=true,
    legend_hideEmpty=false,
    legend_hideZero=false,
    legend_alignAsTable=true,
    legend_rightSide=true,
    legend_show=true,
    legend_sortDesc=true,
    legend_sort='avg',
    editable=true,
    min=0,
  )
  .addTarget(
      prometheus.target(
        'topk(5, rate(mysql_info_schema_table_statistics_rows_changed_total{service_name=~"$service"}[$interval])>0) or topk(5, irate(mysql_info_schema_table_statistics_rows_changed_total{service_name=~"$service"}[5m])>0)',
        refId='A',
        interval='$interval',
        calculatedInterval='2m',
        step=300,
        intervalFactor=1,
        legendFormat='{{ schema }}.{{ table }}',
      )
  ),
  gridPos={
    "h": 7,
    "w": 24,
    "x": 0,
    "y": 29,
  },
  style=null,
)//42 graph
.addPanel(
    row.new(
      title='Auto Increment Usage',
    ),
    gridPos={
      "h": 1,
      "w": 24,
      "x": 0,
      "y": 36,
    },
    style=null,
)//60 row
.addPanel(
  tablePanel.new(
    title='Top Tables by Auto Increment Usage',
    datasource='Prometheus',
    fontSize='100%',
    scroll=false,
    showHeader=true,
    columns=[
        {
          "text": "Current",
          "value": "current"
        }
      ],
    sort={
      "col":21,
      "desc":true,
      },
  )
  .addStyle(
    {
        "alias": "",
        "colorMode": null,
        "colors": [
          "rgba(245, 54, 54, 0.9)",
          "rgba(237, 129, 40, 0.89)",
          "rgba(50, 172, 45, 0.97)"
        ],
        "dateFormat": "YYYY-MM-DD HH:mm:ss",
        "decimals": 2,
        "mappingType": 1,
        "pattern": "node_name",
        "thresholds": [],
        "type": "hidden",
        "unit": "short"
      }
  )
  .addStyle(
    {
        "alias": "",
        "colorMode": null,
        "colors": [
          "rgba(245, 54, 54, 0.9)",
          "rgba(237, 129, 40, 0.89)",
          "rgba(50, 172, 45, 0.97)"
        ],
        "dateFormat": "YYYY-MM-DD HH:mm:ss",
        "decimals": 2,
        "mappingType": 1,
        "pattern": "Time",
        "thresholds": [],
        "type": "date",
        "unit": "short"
      }
  )
  .addStyle(
      {
          "alias": "",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "agent_type",
          "thresholds": [],
          "type": "hidden",
          "unit": "short"
        }
  )
  .addStyle(
      {
          "alias": "",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "az",
          "thresholds": [],
          "type": "hidden",
          "unit": "short"
        }
  )
  .addStyle(
    {
        "alias": "",
        "colorMode": null,
        "colors": [
          "rgba(245, 54, 54, 0.9)",
          "rgba(237, 129, 40, 0.89)",
          "rgba(50, 172, 45, 0.97)"
        ],
        "dateFormat": "YYYY-MM-DD HH:mm:ss",
        "decimals": 2,
        "mappingType": 1,
        "pattern": "/.*_id/",
        "thresholds": [],
        "type": "hidden",
        "unit": "short"
      }
  )
  .addStyle(
    {
          "alias": "",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "custom_label",
          "thresholds": [],
          "type": "hidden",
          "unit": "short"
        }
  )
  .addStyle(
    {
         "alias": "",
         "colorMode": null,
         "colors": [
           "rgba(245, 54, 54, 0.9)",
           "rgba(237, 129, 40, 0.89)",
           "rgba(50, 172, 45, 0.97)"
         ],
         "dateFormat": "YYYY-MM-DD HH:mm:ss",
         "decimals": 2,
         "mappingType": 1,
         "pattern": "node_model",
         "thresholds": [],
         "type": "hidden",
         "unit": "short"
       }
  )
  .addStyle(
    {
        "alias": "",
        "colorMode": null,
        "colors": [
          "rgba(245, 54, 54, 0.9)",
          "rgba(237, 129, 40, 0.89)",
          "rgba(50, 172, 45, 0.97)"
        ],
        "dateFormat": "YYYY-MM-DD HH:mm:ss",
        "decimals": 2,
        "mappingType": 1,
        "pattern": "job",
        "thresholds": [],
        "type": "hidden",
        "unit": "short"
      }
  )
  .addStyle(
    {
          "alias": "",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "instance",
          "thresholds": [],
          "type": "hidden",
          "unit": "short"
        }
  )
  .addStyle(
    {
          "alias": "",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "region",
          "thresholds": [],
          "type": "hidden",
          "unit": "short"
        }
  )
  .addStyle(
    {
          "alias": "",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "service_type",
          "thresholds": [],
          "type": "hidden",
          "unit": "short"
        }
  )
  .addStyle(
    {
          "alias": "",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "cluster",
          "thresholds": [],
          "type": "hidden",
          "unit": "short"
        }
  )
  .addStyle({
          "alias": "",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "node_type",
          "thresholds": [],
          "type": "hidden",
          "unit": "short"
        })
  .addStyle(
    {
          "alias": "",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "replication_set",
          "thresholds": [],
          "type": "hidden",
          "unit": "short"
        }
  )
  .addStyle(
    {
          "colorMode": null,
          "colors": [
            "rgba(50, 172, 45, 0.97)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(245, 54, 54, 0.9)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "pattern": "/.*/",
          "thresholds": [
            "95",
            "98"
          ],
          "type": "number",
          "unit": "percentunit"
        }
  )
  .addTarget(
    prometheus.target(
      'topk(10, mysql_info_schema_auto_increment_column{service_name=~"$service"} / mysql_info_schema_auto_increment_column_max{service_name=~"$service"})',
      intervalFactor = 1,
      refId='A',
      interval='5m',
      format='table',
      legendFormat='{{ schema }}.{{ table }}',
      step=300,
   )
   ),
  gridPos={
   "h": 7,
   "w": 24,
   "x": 0,
   "y": 37,
    },
    style=null,
)//53 table
