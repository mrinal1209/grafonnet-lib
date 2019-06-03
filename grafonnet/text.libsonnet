{
  new(
    title='',
    span=null,
    mode='markdown',
    datasource=null,
    content='',
    transparent=null,
  //  error=null,
    height=null,
    editable=null,
    id=null,
    links=[],
  )::
    {
      [if transparent != null then 'transparent']: transparent,
      [if datasource != null then 'datasource']: datasource,
    //  [if error != null then 'error']: error,
      [if height != null then 'height']: height,
      [if id != null then 'id']: id,
      [if editable != null then 'editable']: editable,
      title: title,
      [if span != null then 'span']: span,
      type: 'text',
      mode: mode,
      content: content,
      links:links,
    },
}
