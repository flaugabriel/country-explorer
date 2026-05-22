class QrcodeCreateService
  def initialize(resource, request)
    @resource = resource
    ActiveStorage::Current.host = request.base_url
  end

  def build
    qrcode = RQRCode::QRCode.new(@resource.provisioning_uri, size: 10, level: :h)
    png = create_png(qrcode)
    blob = create(png)
    blob
  end

  private 

  def create(png)
    ActiveStorage::Blob.create_and_upload!(
      io: StringIO.new(png.to_s),
      filename: 'temp.png',
      content_type: 'image/png'
    )
  end

  def create_png(qrcode)
    qrcode.as_png(
      bit_depth: 1,
      border_modules: 4,
      color_mode: ChunkyPNG::COLOR_GRAYSCALE,
      color: "black",
      file: nil,
      fill: "white",
      module_px_size: 6,
      resize_exactly_to: false,
      resize_gte_to: false,
      size: 120
    )
  end
end