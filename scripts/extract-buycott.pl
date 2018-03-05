#!/usr/bin/perl -w

use PerlLib::SwissArmyKnife;

foreach my $file (split /\n/, `find /var/lib/myfrdcsa/codebases/minor/inventory-manager/data-git/ | grep buycott | grep upc/`) {
  print "<$file>\n";
  my $c = read_file($file);
  if ($c =~ /<img style='max-width: 350px; max-height:200px;' src="[^"]+" alt="\d+ ([^"]+)" title="\d+ ([^"]+)"\/>/sm) {
    print $1."\n";
    print $2."\n";
  } else {
    print "nope\n";
  }
  print "\n";

  # <img style='max-width: 350px; max-height:200px;' src="" alt="038000318207 Kellogg&#x27;s Pop-Tarts Frosted Cherry Toaster Pastries" title="038000318207 Kellogg&#x27;s Pop-Tarts Frosted Cherry Toaster Pastries"/>

  # <td>Description</td>
  # <td>Always Fresh and Factory Sealed!Kelloggs Pop Tarts Flavors: Frosted Cherry Size: One box/8 Pastries ~*~ This listing is for one box of Kelloggs Pop Tarts. Each box has four indiviudally wrapped packages containing two Pop Tart pastries for a total of 8 Pop Tarts. Buy five boxes and get the sixth one free! Let me... 038000318207</td>


  # <td>Description</td>
  # <td>None available for 041498192150</td>



  # <table class="table product_info_table">

  #     <tbody>
  #       <tr>
  #         <td>Brand</td>
  #         <td><h2 style="font-size: 13px; line-height: 17px; font-family: "Biko";"><a href="/brand/13933/loven-fresh-upc">L&#x27;oven FRESH</a></h2></td>
  #       </tr>
  #       <tr>
  #         <td>Company</td>
  #         <td><a href="/company/434978/aldi-benner-company">Aldi-Benner Company</a></td>
  #       </tr>

  #       <tr>
  #         <td>GTIN</td>
  #         <td>00041498191801</td>
  #       </tr>
  #       <tr>
  #         <td>UPC</td>
  #         <td><h1 class="ean">041498191801</h1>, <h2 class="ean">0 41498 19180 1</h2></td>
  #       </tr>
  #       <tr>
  #         <td>EAN</td>
  #           <td><h2 class="ean">0041498191801</h2>, <h2 class="ean">
  #               41498191801
  #           </h2></td>
  #       </tr>




  #         <tr>
  #           <td>Description</td>
  #           <td>Good source of calcium. Good source of vitamin D. Delicious and satisfying, L&#x27;oven Fresh is baked with taste in mind. Available in an entire range of baked goods, L&#x27;oven Fresh brings together the convenience you need and the delicious, fresh tasting bread and baked goods you enjoy. 041498191801</td>
  #         </tr>



  #     </tbody>
  #   </table>



  # (\d+) reasons to buy
  #   (\d+) reasons to avoid




  # <div class="user_block hidden-mob">
  #   <div class="upload_image">
  #     <a href="/campaign/1017/support-scottish-independence"><img src="http://s3.amazonaws.com/buycott/images/attachments/001/260/282/iphone/c8fe0a98c6dbd450f5f5b5311d575bde?1447768073" alt="Support Scottish Independence" title="Support Scottish Independence"/></a>
  #   </div>
  #   <div class="user_text">
  #     <a href="/campaign/1017/support-scottish-independence"><h4>Support Scottish Independence</h4></a>
  #       <div><span>Supermarket prices may fall after independence!</span></div>
  #     <div class="clear"></div>
  #   </div>
  # </div>
  # <div class="user_block_mobile hidden_desktop">
  #   <div class="upload_image"> 

  #     <div class="mobile_campaign_image_container">
  #       <div class="mobile_campaign_image_overlay"></div>
  #       <img src="http://s3.amazonaws.com/buycott/images/attachments/001/260/282/iphone/c8fe0a98c6dbd450f5f5b5311d575bde?1447768073" alt="Support Scottish Independence" title="Support Scottish Independence"/>
  #     </div>

  #     <div class="label_text"> <span class="animal_welfare">Civil Rights</span> 
  #     </div>
  #     <div class="user_text">
  #       <a href="/campaign/1017/support-scottish-independence"><h4>Support Scottish Independence</h4></a>
  #       <span>41 companies</span> 
  #     </div>
  #   </div>
  # </div>



  # <img style='max-width: 350px; max-height:200px;' src="http://s3.amazonaws.com/buycott/images/attachments/001/231/940/original/848ea851b6b1625b82320a3cabe625ce?1438487623" alt="041498191801 L&#x27;oven Fresh Hamburger Buns" title="041498191801 L&#x27;oven Fresh Hamburger Buns"/>
}
