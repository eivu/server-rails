class QrcodeGenerator

  def self.uri_as_ansi(uri)
    @qrcode = RQRCode::QRCode.new(uri)
    @qrcode.as_ansi(
      light: "\033[47m", dark: "\033[40m",
      fill_character: '  ',
      quiet_zone_size: 4
    )
  end


  def self.uri_as_svg(uri)
    @qrcode = RQRCode::QRCode.new(uri)
    @qrcode.as_svg(
      offset: 0,
      color: '000',
      shape_rendering: 'crispEdges',
      module_size: 6,
      standalone: true
    )
  end
end