#!/opt/puppet/bin/ruby
require 'markaby'
require 'json'
require 'uri'
require 'getoptlong'

UNKNOWN_FILE_PATH = 'unknown location'

PUPPET_LOGO = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAYAAAAeP4ixAAAKQWlDQ1BJQ0MgUHJvZmlsZQAASA2dlndUU9kWh8+9N73QEiIgJfQaegkg0jtIFQRRiUmAUAKGhCZ2RAVGFBEpVmRUwAFHhyJjRRQLg4Ji1wnyEFDGwVFEReXdjGsJ7601896a/cdZ39nnt9fZZ+9917oAUPyCBMJ0WAGANKFYFO7rwVwSE8vE9wIYEAEOWAHA4WZmBEf4RALU/L09mZmoSMaz9u4ugGS72yy/UCZz1v9/kSI3QyQGAApF1TY8fiYX5QKUU7PFGTL/BMr0lSkyhjEyFqEJoqwi48SvbPan5iu7yZiXJuShGlnOGbw0noy7UN6aJeGjjAShXJgl4GejfAdlvVRJmgDl9yjT0/icTAAwFJlfzOcmoWyJMkUUGe6J8gIACJTEObxyDov5OWieAHimZ+SKBIlJYqYR15hp5ejIZvrxs1P5YjErlMNN4Yh4TM/0tAyOMBeAr2+WRQElWW2ZaJHtrRzt7VnW5mj5v9nfHn5T/T3IevtV8Sbsz55BjJ5Z32zsrC+9FgD2JFqbHbO+lVUAtG0GQOXhrE/vIADyBQC03pzzHoZsXpLE4gwnC4vs7GxzAZ9rLivoN/ufgm/Kv4Y595nL7vtWO6YXP4EjSRUzZUXlpqemS0TMzAwOl89k/fcQ/+PAOWnNycMsnJ/AF/GF6FVR6JQJhIlou4U8gViQLmQKhH/V4X8YNicHGX6daxRodV8AfYU5ULhJB8hvPQBDIwMkbj96An3rWxAxCsi+vGitka9zjzJ6/uf6Hwtcim7hTEEiU+b2DI9kciWiLBmj34RswQISkAd0oAo0gS4wAixgDRyAM3AD3iAAhIBIEAOWAy5IAmlABLJBPtgACkEx2AF2g2pwANSBetAEToI2cAZcBFfADXALDIBHQAqGwUswAd6BaQiC8BAVokGqkBakD5lC1hAbWgh5Q0FQOBQDxUOJkBCSQPnQJqgYKoOqoUNQPfQjdBq6CF2D+qAH0CA0Bv0BfYQRmALTYQ3YALaA2bA7HAhHwsvgRHgVnAcXwNvhSrgWPg63whfhG/AALIVfwpMIQMgIA9FGWAgb8URCkFgkAREha5EipAKpRZqQDqQbuY1IkXHkAwaHoWGYGBbGGeOHWYzhYlZh1mJKMNWYY5hWTBfmNmYQM4H5gqVi1bGmWCesP3YJNhGbjS3EVmCPYFuwl7ED2GHsOxwOx8AZ4hxwfrgYXDJuNa4Etw/XjLuA68MN4SbxeLwq3hTvgg/Bc/BifCG+Cn8cfx7fjx/GvyeQCVoEa4IPIZYgJGwkVBAaCOcI/YQRwjRRgahPdCKGEHnEXGIpsY7YQbxJHCZOkxRJhiQXUiQpmbSBVElqIl0mPSa9IZPJOmRHchhZQF5PriSfIF8lD5I/UJQoJhRPShxFQtlOOUq5QHlAeUOlUg2obtRYqpi6nVpPvUR9Sn0vR5Mzl/OX48mtk6uRa5Xrl3slT5TXl3eXXy6fJ18hf0r+pvy4AlHBQMFTgaOwVqFG4bTCPYVJRZqilWKIYppiiWKD4jXFUSW8koGStxJPqUDpsNIlpSEaQtOledK4tE20Otpl2jAdRzek+9OT6cX0H+i99AllJWVb5SjlHOUa5bPKUgbCMGD4M1IZpYyTjLuMj/M05rnP48/bNq9pXv+8KZX5Km4qfJUilWaVAZWPqkxVb9UU1Z2qbapP1DBqJmphatlq+9Uuq43Pp893ns+dXzT/5PyH6rC6iXq4+mr1w+o96pMamhq+GhkaVRqXNMY1GZpumsma5ZrnNMe0aFoLtQRa5VrntV4wlZnuzFRmJbOLOaGtru2nLdE+pN2rPa1jqLNYZ6NOs84TXZIuWzdBt1y3U3dCT0svWC9fr1HvoT5Rn62fpL9Hv1t/ysDQINpgi0GbwaihiqG/YZ5ho+FjI6qRq9Eqo1qjO8Y4Y7ZxivE+41smsImdSZJJjclNU9jU3lRgus+0zwxr5mgmNKs1u8eisNxZWaxG1qA5wzzIfKN5m/krCz2LWIudFt0WXyztLFMt6ywfWSlZBVhttOqw+sPaxJprXWN9x4Zq42Ozzqbd5rWtqS3fdr/tfTuaXbDdFrtOu8/2DvYi+yb7MQc9h3iHvQ732HR2KLuEfdUR6+jhuM7xjOMHJ3snsdNJp9+dWc4pzg3OowsMF/AX1C0YctFx4bgccpEuZC6MX3hwodRV25XjWuv6zE3Xjed2xG3E3dg92f24+ysPSw+RR4vHlKeT5xrPC16Il69XkVevt5L3Yu9q76c+Oj6JPo0+E752vqt9L/hh/QL9dvrd89fw5/rX+08EOASsCegKpARGBFYHPgsyCRIFdQTDwQHBu4IfL9JfJFzUFgJC/EN2hTwJNQxdFfpzGC4sNKwm7Hm4VXh+eHcELWJFREPEu0iPyNLIR4uNFksWd0bJR8VF1UdNRXtFl0VLl1gsWbPkRoxajCCmPRYfGxV7JHZyqffS3UuH4+ziCuPuLjNclrPs2nK15anLz66QX8FZcSoeGx8d3xD/iRPCqeVMrvRfuXflBNeTu4f7kufGK+eN8V34ZfyRBJeEsoTRRJfEXYljSa5JFUnjAk9BteB1sl/ygeSplJCUoykzqdGpzWmEtPi000IlYYqwK10zPSe9L8M0ozBDuspp1e5VE6JA0ZFMKHNZZruYjv5M9UiMJJslg1kLs2qy3mdHZZ/KUcwR5vTkmuRuyx3J88n7fjVmNXd1Z752/ob8wTXuaw6thdauXNu5Tnddwbrh9b7rj20gbUjZ8MtGy41lG99uit7UUaBRsL5gaLPv5sZCuUJR4b0tzlsObMVsFWzt3WazrWrblyJe0fViy+KK4k8l3JLr31l9V/ndzPaE7b2l9qX7d+B2CHfc3em681iZYlle2dCu4F2t5czyovK3u1fsvlZhW3FgD2mPZI+0MqiyvUqvakfVp+qk6oEaj5rmvep7t+2d2sfb17/fbX/TAY0DxQc+HhQcvH/I91BrrUFtxWHc4azDz+ui6rq/Z39ff0TtSPGRz0eFR6XHwo911TvU1zeoN5Q2wo2SxrHjccdv/eD1Q3sTq+lQM6O5+AQ4ITnx4sf4H++eDDzZeYp9qukn/Z/2ttBailqh1tzWibakNml7THvf6YDTnR3OHS0/m/989Iz2mZqzymdLz5HOFZybOZ93fvJCxoXxi4kXhzpXdD66tOTSna6wrt7LgZevXvG5cqnbvfv8VZerZ645XTt9nX297Yb9jdYeu56WX+x+aem172296XCz/ZbjrY6+BX3n+l37L972un3ljv+dGwOLBvruLr57/17cPel93v3RB6kPXj/Mejj9aP1j7OOiJwpPKp6qP6391fjXZqm99Oyg12DPs4hnj4a4Qy//lfmvT8MFz6nPK0a0RupHrUfPjPmM3Xqx9MXwy4yX0+OFvyn+tveV0auffnf7vWdiycTwa9HrmT9K3qi+OfrW9m3nZOjk03dp76anit6rvj/2gf2h+2P0x5Hp7E/4T5WfjT93fAn88ngmbWbm3/eE8/syOll+AAAACXBIWXMAAAsTAAALEwEAmpwYAAAImElEQVRoBd1YW2hU2xn+9mVmMjF6khhN1OaCFhMTTdHT5hQvLdhD6YMgRwTRQ1tKH3wKGkQolDy0D4VefBBbCoWW1he1ItI+WKEPx6QIHrHiIRKPQT0ej8cjudTck5k9M7v/t2bWzJ69J4mTiwn+Oll7r8u//u+/rP9f29i8ebOLt4DMtwCDgvDWALFnsohhAPJ/VkqtIKecEYibmhVDenAupK/BYrGmFARC+eLidA5cZRUqnn3+NuquHCQBIKtCQM9DoOs3IezYGEfMERA+eU3DxXQyhPa/JvDPTw1sXSOgX8eCi6X+AnwCQKyM0OtXJ1FRHqNZANMTDLSCAEkmgZKQATcRBFpgnyXvCgDRIjspEThpKIETThipTOiHzQQsIykWEBB68pKLOfcGgeNXe1G6TcGybfy528IPfu3ih390MTgu2G1BsJJQCM4AkDzs1LgESP8o0P1fA1c+AhKeWPDHTt7aN/wScK28/WkW0Xz1Oy7eb3OxdrUBOwNde1VIDoeVYJwAEC1gWjgTSSeBn34H+Mm+NIKQxAhjxzYNxCXgnX4X0UoDsWkxr/bLPG28mZeAa2lZQoQosWBJGw47KIlMq59lJ8FkGbId/OqImGMj8HwEKAsDy5npAxZJZkzy1YiJdaURTPN49Sl1Y4VMSsbQtGkSn3aWoukXDowxA5vXSiL1zCcrxtGEHOG0np+Pj+2CXo1CZTw3HHJcDBOVJ6KrxACDT1387XQEP9rnIBWbhBkJ4eGLKJp+KQhe8CTwiys8qiRplhtwCMY/vCDxc4sLAuEw/T3gd9IfFRt+8jCVBePGJ2GEQ/i8P4zPB1Licrn84kqghUImLt9y8bsrLpq3GMrCue0X7yngWpo13cJz0qpu9k2I4r/VYuHHv5WsD7HMnlK48SnUV6VQXy3oOYlEzTNoIjY++cwSV5RHaeiqS0EzAxEZtEzejdk3NOXi29tNBaZmjYXvf8OSkJECM5G/ghaxhEs8058/6uW68OcZgczFOqbMZeDlK1G1qJ+FpN//leBiGX//XLznM14oDF6PT0a9jImVQPMGspRuMh/FzMu1GMMlyhKu3FfSkPjXb5tCfV4hDfE5/hhLJN2Gw2HYUqymUinE43HVetcVei4aCEG8UwLcepZCc6uB/dt5IsWFN2GkBdIbmeo9fcvUfd6WIEwz7RQUOhqNKmA9PT3ZaVu2bEF5eTlGR0dnBVQQCMXhTVEXiJorFcfL1McCYlutiX91WKhbOyEFlwtTNJhIUMM5MK4AseVf+i7DtxwRRH9/vxKQvVVVVRgcHFQTjh07hrq6OgwNDeHq1at4/Pgxtm7dqqwUi8UU2Byn9FMgIXIzyWHoe+Td1rvMRUurhWsdNuoqxwWEnFr2Kvyly8B/eh2sjhqiufR8crAks/Z+Cdx/aWB1ph4rKSlBb28v7t69qwROynVzYmICFy9exOHDh9HQ0CCJNCSXuiSGh4fR3d2NQ4cOYf369aisrEQhMAEgtEKfyNf5vomvVchNkGVFBocoUd3hP3jPRv26SUmESRh2KX7/bxvtf5CCSqpgyNoscaEkwKoNQHkkV1SWlpbi/v37ePHiK2zYUJOdTsEtS1xVSMcLLUd68OABmpub80CqgcyfgGuVsucl8OE+C4214vu8s3uJjJNpd8qBiOM9SZBjDJUq7+S0ElgwMiemRcoJ6ThcIOwEAGNFg2CfBsDYIaht27bh5s2b2LNnD3bu3ImRESm5PRQAoh0qTlNIKZsUIJbERbbwknhgwJt2GH/6yBJLxNEmIPonc4J6+GcfNQh2aCG9LZ8dx8G1a9eUy9GFDh48qCygrbN7926cOHECZ8+eRUtLC6amprL8A0D0hmoTeaGWer4IY2BULlNi9XfrHawqiWNaPnxdueVg3SYTI1J26XVZzvN4OHfuHE6dOpVdefLkSTx9+hT19fVykCRUsB84cEABYZx5gcyeEHlMCZC/fwx87+cJfPdnCQxPCRq1ykWVXH0HRCkLBUG3mp6exvXr1yHXCuU6e/fuVYAuXbqkWtNIi8pxEq3npdmBZGZqd1N5IpO8OOT9EOFlOp9ngqmoqMCTJ0+UpgcGBhSbO3fuqKRoWmlReVCQCFy7Jt8DrsXOLKnATuKDb9rY/fWQyitrohKgRMaxRSYdC5otsztdyttP4elW7OOzHgsA0dpXE+QlISfKuw3iPyoDSwe/jfJOoSwjYBYJD08napmJkNYpKytTIHhaRSIRldXZH5uOqXkEw9yjKeBaWq4ws2LYhB2WmKB/UnCiDMm73JAiMqaw+W9fmnMRLZVGYVmOPHv2TAl4+/ZtxeHIkSOqJVDS8y+fq5YJ00sBi0xR25IL/nHHRcNnITi+soMmEIOKYUw8/18K1WULjxUCobY7OztRU1ODrq4u7N+/H8ePH0dra6tyH46Tbty4oVq6nJcCmV0pXdbMXKLklm+qMxAVxTCvFEM6s1P7tbW1WT/XwUsXYwVM4QmSCZPx0tfXh8bGRuzYsSPPrbh3wCJ0LYbB9kYD9Cp6VCFiNzN5sSAK8fL36WDWJQtBsIDs6OhQU/3WYGfaXj5OBDMpx/SwfD1ksiv0G5X+mUD62M35SkswuV2+fFkViVzAPiZjCn3v3j0cPXpUZX1aw5sINfOAa+mBpWz9rsW9eIFqa2vDq1ev0N7ernLK5OQkmEfOnz+vquGmpiaMjY0pl/PLF3At/4Q39c5YYHV74cIFnD59Om9bFom0wvj4eEEQnLxigFAYWoUutWvXLpU3CI53D13p6sOAc/20ooBQOArPREdQxVDBYC+GwULm6txAHnyeTeNz7bMsFmGeqK6uxpkzZ9SHBWZtHrW8mzOv+CvbuUBwfFlOLW5MCzx69IiPWWKdxdKD7lUsLRsQCsrPP8wVWnAet/q5WCDL4lpayEKJTY8V2y5rsBcr7Gzz3xog/wdjyGDqXjzftQAAAABJRU5ErkJggg=='


opts = GetoptLong.new(
  [ '--format_json',   '-f', GetoptLong::REQUIRED_ARGUMENT],
  [ '--write_html',    '-w', GetoptLong::REQUIRED_ARGUMENT],
  [ '--help',    '-h', GetoptLong::NO_ARGUMENT ],
)


def show_usage()
  puts <<-EOF
preview_report.rb [OPTIONS]
-h, --help
  show help
-f, --format_json [/path/to/output.json]
  The path to overview-json file created by puppet preview i.e. --view overview-json
-w, --write_html [/path/to/saved_report.html]
  The path to where you would like to save the html report 
  EOF
  exit 1
end


opts.each do |opt,arg|
  case opt
  when '--help'
    show_usage
  when '--format_json'
    @overview_json = arg
  when '--write_html'
    @html_file = arg
  end
end


if (@overview_json.nil? or @html_file.nil?)
  show_usage
end

def load_json(filename)
  JSON.parse( IO.read(filename) )
end


def find_diffs(diff_path)
  found_diffs = []
  Dir.glob("#{diff_path}/*/catalog_diff.json") do |catalog_diff|
    found_diffs << catalog_diff
  end
  found_diffs
end

overview = load_json(@overview_json)
stats   = overview['stats']
preview = overview['preview']

mab = Markaby::Builder.new
mab.html do
  def make_error_readable(error)
      h5.entryTitle "Information about this issue"
      case error
      # MIGRATE4_REVIEW_IN_EXPRESSION
      when 'MIGRATE4_REVIEW_IN_EXPRESSION'
        tag! :body, :id => "overview_#{error}_#{rand()}" do
          <<-eos
          In Puppet 3, the #{tag! :code, 'in'} operator was not well specified and there were several undefined behaviors. This relates to, but is not limited to:
          eos
        end
        ul do
          li 'String / numeric automatic conversions.'
          li 'Applying regular expressions to non string values causing auto conversion.'
          li 'Confusion over comparisons between empty string/undef/nil (internal) values.'
          li 'In-operator not using case independent comparisons in Puppet 3.'
        end
        br
        body 'To fix, review the expectations against the Puppet language specification.'
        br
        body "For a detailed description of this issue, see "
        a 'PUP-4130', :href => 'https://tickets.puppetlabs.com/browse/PUP-4130'
      else
        tag! :body, :id => "overview_#{error}_#{rand()}" do
           a :href => "https://forge.puppet.com/puppetlabs/catalog_preview#%s" % error.downcase do
             tag! :i, "No information defined for this error click here for more infromation"
           end
        end
      end
  end

  def normalize_name(name)
    #name.downcase.gsub(/[\-\[\] :\/\.]/,'_')
    URI.escape(name).gsub(/[\-\[\] :\/\.]/,'_').to_s
  end

  def read_code_off_disk(header,manifest,line_number)
    line_number = (line_number.to_i + 1)
    # Read the file off disk to find the code question.
    file = File.readlines(manifest)
    #### Manifests Code Block
    css = [
      'color: black',
      'background-color: white',
      'border-width: 1px',
      'border-bottom-width: 1px;',
      'border-bottom-style: dotted',
      'border-left-width: 4px',
      'border-style: dotted solid',
      'border-color: rgb(221, 221, 221);',
      'padding-bottom: 10px;',
    ]
    div :style=>css.join(';') do
      tag! :code, :id => "manifest_#{header}_#{manifest}_#{line_number}_#{rand()}" do
        ((line_number - 1)..(line_number + 1)).each do |nu|
          div.entryContent do
            if nu == line_number - 1
              div :style=> "background-color:rgb(248,238,199)" do
                tag! :font, :color => 'black' do
                "#{tag! :b, nu}:#{file[(nu - 1)]}"
                end
              end
             else
              div :style=> "background-color:white" do
                tag! :font, :color => 'black' do
                "#{nu}:#{file[(nu - 1)]}"
                end
              end
             end
          end
        end
      end
    end
  end

  def node_break_down(nodes, resource =nil)
    ul do
      # Only show 10 nodes
      body "This issue occured on #{nodes.length} nodes"
      ul do
        nodes[0..10].each do |node|
           div :style=>"font-size: 1.0rem;" do
             tag! :font, :color => 'black' do
               # LINK 2 or LINK 3
               li do
                 if resource.nil?
                   a node, :href => '#%s' % node_name(node)
                 else
                   a node, :href => '#%s' % normalize_name("#{node}_#{resource}")
                 end
               end
             end
           end
        end
      end
    end
  end

  def process_breakdown(header,type,detail)
    h3 "Detected #{header} #{type} resources"
    detail.each do |title,breakdown|
      ul do
        li do
          div :style=>"font-size: 1.3rem;" do
            # LINK 01
            a :name => normalize_name("#{header}_#{type}_#{title}") do
              "#{type}[#{title}] is #{header}"
            end
          end
        end
        breakdown.each do |path,nodes|
        #### Example nodes
          css = [
            'color: black',
            'border-radius: 10px',
            'background-color: white',
            'font-family: "Helvetica Neue",Helvetica,Arial,sans-serif";',
            'border-bottom-width: 1px;',
            'border-bottom-style: dotted;',
            'border-bottom-color: rgb(221, 221, 221);',
            'padding-bottom: 20px;',
          ]
          div :style=>css.join(';') do
              ul do
                ul do
                  # Path for classes is unknown
                  unless path == UNKNOWN_FILE_PATH
                     file_path,line_number = path.split(':')
                     h5.entryTitle "#{header.capitalize} resource ending on line #{line_number} (view node report for details)"
                     p path
                     read_code_off_disk(header,file_path,line_number)
                     br
                    end
                  end
                  # N number of example nodes
                  node_break_down(nodes,"#{type}[#{title}]")
                  br
            end
          end
        end
      end
    end
  end

  def header1(title)
    css = [
      'color: #33353f',
      'background-color: #dcdcdc',
      'font-size: 10px',
      'line-height: 20px',
      'display: block',
      'letter-spacing: normal',
      'padding: 15px',
      'border-radius: 10px',
      'margin: 0',
      'font-family: "Helvetica Neue",Helvetica,Arial,sans-serif";'
    ]
    div :style=>css.join(';') do
      h1 do
        a title, :name => normalize_name(title)
      end
    end
  end

  def header2(title)
    css = [
      'color: #33353f',
      'background-color: #f5f5f5',
      'font-size: 20px',
      'line-height: 20px',
      'display: block',
      'letter-spacing: normal',
      'padding: 15px',
      'border-radius: 15px',
      'margin: 0',
      'font-family: "Helvetica Neue",Helvetica,Arial,sans-serif";'
    ]
    div :style=>css.join(';') do
      h2 title
    end
  end

  def header4(title)
    css = [
      'color: #33353f',
      'background-color: #f5f5f5',
      'font-size: 1.0rem',
      'line-height: 10px',
      'display: block',
      'letter-spacing: normal',
      'padding: 5px',
      'border-radius: 5px',
      'margin: 0',
      'font-family: "Helvetica Neue",Helvetica,Arial,sans-serif";'
    ]
    div :style=>css.join(';') do
      h4 title
    end
  end

  head do
    title "Diff Overview"
      meta :name => "keywords", :content => "puppet, diff, preview"
      style :type => "text/css" do
        %[
          body { font: 20px/120% "Helvetica Neue",Helvetica,Arial, sans-serif }
        ]
      end
  end
  body :bgcolor => '#ffffff' do
    css = [
      'color: white',
      #'background-color: #f9f9f9',
      'background-color: #1a1a1a',
      'line-height: 20px',
      'display: block',
      'letter-spacing: normal',
      'height: 50px',
      'padding: 0px',
      'margin: 0',
      'border-bottom-width: 3px',
      'border-bottom-style: solid',
      'border-bottom-color: rgb(204,204,204)',
      'font-family: "Helvetica Neue",Helvetica,Arial,sans-serif"',
      'font-size: 2.0rem',
      'margin-left: 60px;',
      'float: left',
    ]
    div :style=>css.join(';') do
       img :src => PUPPET_LOGO
    end
    error_message = Hash.new
    # TOC
    header1 "Catalog Preview Report"
    ul do
      [
        "Top 10 nodes with issues",
        "Catalog Compliation Known Issues",
        "Resource Breakdown",
        "Node breakdown",
      ].each do |title|
        li do
          a title, :href => "#%s" % normalize_name(title)
        end
      end
    end
    # TOP TEN
    header1 "Top 10 nodes with issues"
    hr
    body "The following nodes had the most issues including missing or conflicting catalogs."
    br
    body "These nodes are likely the best for testing the breakdown issue list below."
    ul do
      overview['top_ten'].each do |node|
        #puts node
        preview_log = load_json("/var/opt/lib/pe-puppet/preview/#{node['name']}/preview_log.json")
        li do
          a :href => '#%s' % normalize_name(node['name']) do
            css = [
              'color: black',
              'text-decoration: none',
              'font-size: 1.2rem',
            ]
            div :style=>css.join(';') do
              "#{tag! :b,node['issue_count']} issues on #{tag! :b, node['name']}"
            end
          end
        end
        ul do
          preview_log.each do |issue|
            li do
              # Find file path in error if we don't have a file path from preview
              match = /(\S*(\/\S*\.pp|\.erb))/.match(issue['message'].to_s)
              if issue['file'].nil? and match
                issue['file'] = match[1]
              end
              # Work around the fact overview doesn't have human readable messages
              # we store them here and then use them in the breakdown below
              error_message[issue['issue_code']] = issue['message']
              a "#{issue['file']}:#{issue['line']}", :href => "#%s" % normalize_name(issue['file'])
            end
          end
        end
      end
    end
    total_failures = stats['failures']['total'] || 0

    # FAILURES
    unless total_failures == 0 
      header1 "Catalog Compliation Failures"
      div.failure_overview! {
        # 0 out X summary
        <<-eos
        #{tag! :strong,total_failures} out of #{stats['node_count']} nodes failed to compile their catalog.
        This is #{tag! :strong, stats['failures']['percent']}% failure rate across your infrastructure
        eos
      }
      # FILE WITH ISSUES 
      header1 "Files that caused the most failures"
      # Compliation Errors Breakdown
      ul do
        next unless preview['compilation_errors']
        preview['compilation_errors'].each do |error|
          ul do
            li "#{error['nodes'].size} nodes failed to compile: #{error['manifest']}"
            ul do
              div.entry do

                #### Error by line breakdown
                error['errors'].each do |e|
                  h4.entryTitle "#{e['message']} on line #{e['line']}"
                  # Find file path in error if we don't have a file path from preview
                  match = /(\S*(\/\S*\.pp|\.erb))/.match(e['message'].to_s)
                  if error['manifest'].nil? and match
                    error['manifest'] = match[1]
                  end
                  if error['manifest']
                    # Read the file off disk to find the code question
                    read_code_off_disk('failed',error['manifest'],e['line'])
                  end
                  #### Example nodes
                  node_break_down(error['nodes'])
                end
              end
            end
          end
        end
      end
    end
    # CONFLICTS
    if stats['conflicting']
      header1 "Catalog Compliation Known Issues"
      hr
      total_conflicts = stats['conflicting']['total'] || 0
      css = [
        'border-left-width: 3px',
        'border-left-style: solid',
        'border-left-color: rgb(0, 136, 204)',
        'background-color: #fff',
        'box-shadow: 0 1px 1px rgba(0, 0, 0, 0.05)',
        'padding-top: 15px',
        'padding-right: 15px',
        'padding-bottom: 15px',
        'padding-left: 15px',
      ]
      div :style=>css.join(';') do
        # 0 out X summary
        <<-eos
        #{tag! :strong,total_conflicts} out of #{stats['node_count']} nodes have conflicts/differences in their catalog.
        This is #{tag! :strong, stats['conflicting']['percent']}% conflict rate across your infrastructure
        eos
      end
      preview['warning_count_by_issue_code'].each do |issue|
        css = [
          'color: black',
          'font-family: "Helvetica Neue",Helvetica,Arial,sans-serif";',
        ]
        div :style=>css.join(';') do
          ul do
            issue['manifests'].each do |manifest,lines|
              li do
                a :name => normalize_name(manifest) do
                   css = [
                     'color: black',
                     'text-decoration: none',
                     'font-size: 1.2rem',
                   ]
                  div :style=>css.join(';') do
                    tag! :b, manifest
                  end
                end
              end
              ul do
                #### Error by line breakdown
                lines.uniq.each do |linepos|
                  line_number = linepos.split(':')[0]
                  # Use the preview message human readable and fallback to issue code when not present
                  h4.entryTitle do
                    css = [
                     'color: #666',
                    ]
                    div :style=>css.join(';') do
                      "Line #{line_number}: #{error_message[issue['issue_code']] || issue['issue_code']}"
                    end
                  end

                  read_code_off_disk('warning',manifest,line_number)

                  br
                  # Show human reable error or link
                  make_error_readable(issue['issue_code'])
                end
              end 
            end
          end
        end
      end
      # CHANGES
      if overview['changes']
        header1 "Resource Breakdown"
        hr
        overview['changes']['resource_type_changes'].each do |type,details|
          ul do
            # Type i.e. Class,File 
            header2 type
            hr
            if details['missing_resources']
              process_breakdown('missing',type,details['missing_resources'])
            end
            if details['conflicting_resources']
              process_breakdown('conflicting',type,details['conflicting_resources']) 
            end
          end
        end
      end
      # NODES
      header1 "Node breakdown"
      ul do
        find_diffs('/var/opt/lib/pe-puppet/preview/').each do |catalog_diff_file|
          #puts catalog_diff_file
          if File.zero?(catalog_diff_file)
            body "Diff file empty on disk: #{catalog_diff_file}"
            next
          end
          catalog_diff = load_json(catalog_diff_file)
          li do
            h3 do
              a catalog_diff['node_name'], :name => normalize_name(catalog_diff['node_name'])
            end
          end
          # Node stats table
          ul do
            table do
              td do
                  graph = {
                    'baseline_resource_count'      => 'grey',
                    'preview_resource_count'       => 'black',
                    'missing_resource_count'       => 'red',
                    'added_resource_count'         => 'green',
                    'conflicting_resource_count'   => 'blue',
                  }
                  table do
                    graph.each do |key,color|
                      next if catalog_diff[key].nil?
                      next if catalog_diff[key].zero?
                      css = [
                        'color: white',
                        "background-color: #{color}",
                        'text-align: center ',
                        'position: relative',
                        "width: #{(catalog_diff[key])}px",
                        "line-height: #{(catalog_diff[key])}px",
                        'border-radius: 50%',
                        'text-align: center',
                      ]
                      td do
                        div :style => css.join(';') do
                          body catalog_diff[key]
                        end
                        div :style => 'font-size: smaller;color: black;' do
                          tag! :b, key.capitalize.gsub('_',' ')
                        end
                      end
                    end
                  end
                end
              end
              table do
                count = 0
                catalog_diff.each do |key,value|
                  next if ['added_resources','missing_resources','conflicting_resources','missing_edges','produced_by','timestamp','node_name'].include?(key)
                  next if value.nil?
                  if value.kind_of?(Array) then next if value.empty? end
                  next if value == 0
                  count += 1
                  if count.even?
                    color = 'white'
                  else
                    color = '#f5f5f5'
                  end
                  
                  css = [
                    'color: black',
                    'font-family: Helvetica, Arial, sans-serif',
                    'border-collapse: collapse',
                    'border-style: solid',
                    'border-spacing: 1px',
                    'border-width: 1px',
                    'padding-bottom: 1px',
                    'background-clip: padding-box',
                    "background-color: #{color}",
                    'border-color: #dcdcdc',
                    'width: 768px',
                  ]
                  div :style=>css.join(';') do
                    table  do
                        th_css = [
                          'background: grey',
                          'font-weight: bold',
                        ]
                        div :style=>th_css.join(';') do
                          th "#{key.capitalize.gsub(/_/,' ')}:"
                        end
                        td_css = [
                          'background: #FAFAFA',
                          'text-align: center',
                        ]
                        div :style=>td_css.join(';') do
                          td value
                        end
                      end
                    end
                end
              end
              tag! :i, "Last compiled: #{catalog_diff['timestamp']} with #{catalog_diff['produced_by']}"
            end
            # NODE Level Conflicts
            if catalog_diff['missing_resources']
              header4 "Missing Resources on #{catalog_diff['node_name']}" unless catalog_diff['missing_resource_count'].zero?
              catalog_diff['missing_resources'].sort_by{ |h| h['type']}.each do |missing|
               ul do
                 li do
                   # LINK 01 
                   a :href => normalize_name("#missing_#{missing['type']}_#{missing['title']}") do
                   '%s[%s]' % [missing['type'],missing['title']]
                   end
                 end
                end
              end
            end
            if catalog_diff['added_resources']
              header4 "Added Resources on #{catalog_diff['node_name']}" unless catalog_diff['added_resource_count'].zero?
              catalog_diff['added_resources'].sort_by{ |h| h['type']}.each do |added|
               ul do
                 li do
                   # LINK 01
                   a :href => normalize_name("#added_#{added['type']}_#{added['title']}") do
                   '%s[%s]' % [added['type'],added['title']]
                   end
                 end
                end
              end
            end
            if catalog_diff['conflicting_resources']
              header4 "Conflicting Resources on #{catalog_diff['node_name']}"
              ul do 
                catalog_diff['conflicting_resources'].each do |conflict|
                  li do
                    a :href => '#%s' % normalize_name("conflicting_#{conflict['type']}_#{conflict['title']}"),:name => normalize_name("#{catalog_diff['node_name']}_#{conflict['type']}[#{conflict['title']}]") do
                      "#{conflict['type']}[#{conflict['title']}]"
                    end
                  end
                  ul do
                    ul do
                      conflict['conflicting_attributes'].each do |attribute|
                        css = [
                          'color: black',
                          'background-color: white',
                          'border-width: 1px',
                          'border-bottom-width: 1px;',
                          'border-bottom-style: dotted',
                          'border-style: dotted solid',
                          'border-color: rgb(221, 221, 221);',
                          'padding-top: 15px',
                          'padding-right: 15px',
                          'padding-bottom: 15px',
                          'padding-left: 15px',
                          'border-left-width: 4px',
                          'width: 768',
                        ]
                        div :style=>css.join(';') do
                           ['%s{ \'%s\':'   % [conflict['type'].downcase,conflict['title'].downcase],
                            '- %s => %s' % [attribute['name'],attribute['baseline_value'].inspect],
                            '+ %s => %s' % [attribute['name'],attribute['preview_value'].inspect],
                            '}',
                           ].each do |line|
                           tag! :code do
                             if line =~ /^\-.*/
                               div :style=> "background-color:#ffecec" do
                                 tag! :font, :color => '#bd2c00' do
                                 "#{line}&nbsp;"
                                 end
                               end
                             elsif line =~/^\+.*/
                               div :style=> "background-color:#eaffea" do
                                 tag! :font, :color => '#55a532' do
                                 "#{line}&nbsp;"
                                 end
                               end
                             else
                               line
                             end
                           end
                          end
                        end
                      end
                    end
                end
              end
            end
          end
        end
      end
    end
  end
end

File.write(@html_file, mab.to_s)