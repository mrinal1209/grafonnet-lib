{
  new(
    title,
    type,
    id=null,
    datasource=null,
  )::
    {
      title: title,
      type: type,
      datasource: datasource,
      id: id,
      targets: [
      ],
      links: [],
      _nextTarget:: 0,
      addTarget(target):: self {
        local nextTarget = super._nextTarget,
        _nextTarget: nextTarget + 1,
        targets+: [target { refId: std.char(std.codepoint('A') + nextTarget) }],
      },
    },
}
