# frozen_string_literal: true

require 'rails_helper'

BING_ADWORDS_TOP_URLS = [
  'https://www.bing.com/aclick?ld=e8GmpoFKubrWZl5KW6X5VAwTVUCUwm0HjIEuKogQ32djrza1ckeg7_Efq_PR7equralKIqFaqRu0dCvLlDrR_0GM_Qqk98CGvc-GmaC9vHw_2GmjnTBMmY3YksD8jR2Lq2IbChH0Jhtt1RsPlYZjMs262rr0eLlxLoOFxRyeJqS_wNCyGd51rVRCqGn1vIcW0jKFFF3Q&u=aHR0cHMlM2ElMmYlMmZ3d3cudmVyc2FjZS5jb20lMmZpbnRlcm5hdGlvbmFsJTJmZW4lMmZncmVjYS1sb2dvLWNocm9uby13YXRjaC1wbnVsJTJmUFZFWjkwMDQtUDAwMjFfUlRVX1RVX1BOVUxfXy5odG1sJTNmZ2xDb3VudHJ5JTNkVEglMjZnY2xpZCUzZDc5MmE3ODE1YzcyOTE1YjJmZWY4MWM4NjMzN2Y3ODVjJTI2Z2Nsc3JjJTNkM3AuZHMlMjZtc2Nsa2lkJTNkNzkyYTc4MTVjNzI5MTViMmZlZjgxYzg2MzM3Zjc4NWMlMjZ1dG1fc291cmNlJTNkYmluZyUyNnV0bV9tZWRpdW0lM2RjcGMlMjZ1dG1fY2FtcGFpZ24lM2QwNV9TaG9wcGluZ19BbGwlMjUyMFByb2R1Y3RfSU5UJTI1MjBUSCUyNnV0bV90ZXJtJTNkNDU4MTM5MDA5MTc4NTg5OSUyNnV0bV9jb250ZW50JTNkTWVu&rlid=792a7815c72915b2fef81c86337f785c',
  'https://www.bing.com/aclick?ld=e86Hp7CHJb-QP7JrczLL7I_TVUCUyZ0HAYZYI2Wvvvy70knGCri6DQ2FsHE86N8cJ-OtR-iUP4_7wfyLa0aNCRdC0-SLM3SDBySFdB8qebSst4eBbFRcyXKo8IW5UdIOCF0dr2CMk-gdKR082AA85G-t0P1odokFBo5HRP0RUUxEZzIBREJpOW5Ir03_92SuQ_EIU0lg&u=aHR0cHMlM2ElMmYlMmZ3d3cudmVyc2FjZS5jb20lMmZpbnRlcm5hdGlvbmFsJTJmZW4lMmZtZWR1c2EtaWNvbi1kaWFtb25kLXdhdGNoLXBudWwlMmZQVkVaMjAwNy1QMDAyMl9SVFVfVFVfUE5VTF9fLmh0bWwlM2ZnbENvdW50cnklM2RUSCUyNmdjbGlkJTNkOTk3YjI5ZGRhZWExMTU4ODI5M2I0ZDRlNWFmNzIxZTMlMjZnY2xzcmMlM2QzcC5kcyUyNm1zY2xraWQlM2Q5OTdiMjlkZGFlYTExNTg4MjkzYjRkNGU1YWY3MjFlMyUyNnV0bV9zb3VyY2UlM2RiaW5nJTI2dXRtX21lZGl1bSUzZGNwYyUyNnV0bV9jYW1wYWlnbiUzZDA1X1Nob3BwaW5nX0FsbCUyNTIwUHJvZHVjdF9JTlQlMjUyMFRIJTI2dXRtX3Rlcm0lM2Q0NTgxNzMzNjg4OTEzOTgyJTI2dXRtX2NvbnRlbnQlM2RXb21lbg&rlid=997b29ddaea11588293b4d4e5af721e3'
].freeze

BING_NON_ADWORDS_URLS = [
  'https://www.apple.com/th/watch/',
  'https://www.bnn.in.th/th/p/apple/apple-watch/apple-watch-series-7',
  'https://proreview.co/apple-watch-%e0%b8%a3%e0%b8%b8%e0%b9%88%e0%b8%99%e0%b9%84%e0%b8%ab%e0%b8%99%e0%b8%94%e0%b8%b5/',
  'https://productnation.co/th/27571/Smartwatch-%E0%B8%94%E0%B8%B5%E0%B8%97%E0%B8%B5%E0%B9%88%E0%B8%AA%E0%B8%B8%E0%B8%94-%E0%B8%A3%E0%B8%B5%E0%B8%A7%E0%B8%B4%E0%B8%A7-%E0%B8%A3%E0%B8%B2%E0%B8%84%E0%B8%B2/',
  'https://instore.studio7thailand.com/watch/',
  'https://www.siamphone.com/smartwatch/apple/watch-series-7',
  'https://www.apple.com/watch/',
  'https://www.wired.com/gallery/best-apple-watch/',
  'https://www.target.com/c/apple-watch/sale/-/N-4xuddZ5tdv0',
  'https://www.apple.com/th/shop/buy-watch/apple-watch',
  'https://ipricethailand.com/apple/watch/',
  'https://www.apple.com/th/apple-watch-series-8/',
  'https://www.netflix.com/',
  'https://www.facebook.com/watch',
  'https://www.amazon.com/watch/s?k=watch',
  'https://www.rolex.com/watches',
  'https://store.google.com/us/product/google_pixel_watch?hl=en-US',
  'https://www.amazon.com/watches/s?k=watches',
  'https://wacth.tv/'
].freeze

RSpec.describe Parse::BingParseService, type: :service do
  describe '#parse' do
    context 'given the html_code is valid' do
      it 'returns parse result', vcr: 'services/search/bing/valid' do
        search_service = Search::BingSearchService.new(keyword: 'watch')
        html_code = search_service.search

        parse_service = described_class.new(html_code)
        parse_result = parse_service.parse

        expect(parse_result).to eq(
          {
            adwords_top_urls: BING_ADWORDS_TOP_URLS,
            adwords_top_count: 2,
            adwords_total_count: 2,
            non_adwords_urls: BING_NON_ADWORDS_URLS,
            non_adwords_count: 19,
            total_links_count: 21
          }
        )
      end
    end

    context 'given an INVALID html_code' do
      it 'raises an error' do
        expect { described_class.new(nil) }.to raise_error(IcRailsHueyToby::Errors::ParseServiceError)
      end
    end
  end
end
