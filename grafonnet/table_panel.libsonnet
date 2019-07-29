{
  /**
   * Returns a new table panel that can be added in a row.
   * It requires the table panel plugin in grafana, which is built-in.
   *
   * @param title The title of the graph panel.
   * @param span Width of the panel
   * @param description Description of the panel
   * @param datasource Datasource
   * @param min_span Min span
   * @param styles Styles for the panel
   * @return A json that represents a table panel
   */
  new(
    title,
    description=null,
    span=null,
    min_span=null,
    datasource=null,
    columns=[],
    fontSize=null,
    links=[],
    maxPerRow=null,
    repeat=null,
    pageSize=null,
    repeatDirection=null,
    repeatIteration=null,
    repeatPanelId=null,
    scroll=null,
    showHeader=null,
    sort=null,
  ):: {
    type: 'table',
    title: title,
    [if span != null then 'span']: span,
    [if min_span != null then 'minSpan']: min_span,
    datasource: datasource,
    targets: [
    ],
    styles:[],
    columns:columns,
    links:links,
    [if fontSize != null then 'fontSize']: fontSize,
    [if maxPerRow != null then 'maxPerRow']: maxPerRow,
    [if repeat != null then 'repeat']: repeat,
    [if pageSize != null then 'pageSize']: pageSize,
    [if repeatDirection != null then 'repeatDirection']: repeatDirection,
    [if repeatIteration != null then 'repeatIteration']: repeatIteration,
    [if repeatPanelId != null then 'repeatPanelId']: repeatPanelId,
    [if description != null then 'description']: description,
    [if scroll != null then 'scroll']: scroll,
    [if showHeader != null then 'showHeader']: showHeader,
    [if sort != null then 'sort']: sort,
    transform: 'table',
    _nextTarget:: 0,
    addTarget(target):: self {
      // automatically ref id in added targets.
      // https://github.com/kausalco/public/blob/master/klumps/grafana.libsonnet
      local nextTarget = super._nextTarget,
      _nextTarget: nextTarget + 1,
      targets+: [target { refId: std.char(std.codepoint('A') + nextTarget) }],
    },
    addStyle(style) :: self {
      styles+:[style],
      },
    },
}
