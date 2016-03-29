<xsl:stylesheet version = '1.0'
     xmlns:fo="http://www.w3.org/1999/XSL/Format"
     xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml"/>
 
  <xsl:param name="gendate">
  </xsl:param>
  <xsl:param name="lid"/>
 
  <xsl:template match="file">
    <xsl:variable name="locname" select="$lid" />
    <fo:root>
      <fo:layout-master-set>
        <fo:simple-page-master master-name="late-notice">
          <fo:region-body margin="25mm"/>
        </fo:simple-page-master>
      </fo:layout-master-set>
      <xsl:apply-templates/>    
    </fo:root>
  </xsl:template>
  <xsl:variable name="empty_string" />
 
  <xsl:template match="notice">
    <xsl:if test="location/name[contains(text(), $lid)]"> 

     <!--Milton Freewater Gets Notices For Email/No Email Patrons -->
      <xsl:if test="(location/shortname = 'um-mf')">
        <xsl:if test="@notify_interval = '7 days' or @notify_interval = '14 days' or @notify_interval = '21 days' or @notify_interval = '30 days' or @notify_interval = '60 days' or @notify_interval = '90 days'">
          <xsl:call-template name="notice_template"/>
        </xsl:if>
      </xsl:if>
      <xsl:if test="patron/email = '' and (location/shortname = 'hr-hrhs')">
        <xsl:if test="@notify_interval = '7 days' or @notify_interval = '14 days' or @notify_interval = '30 days'">
          <xsl:call-template name="notice_template"/>
        </xsl:if>
      </xsl:if>
      <xsl:if test="patron/email = '' and (location/shortname = 'wc-dalles' or location/shortname = 'wc-swcl')">
        <xsl:if test="@notify_interval = '7 days' or @notify_interval = '14 days' or @notify_interval = '60 days'">
          <xsl:call-template name="notice_template"/>
        </xsl:if>
      </xsl:if>
      <xsl:if test="patron/email = '' and (location/shortname = 'hr-cll' or location/shortname = 'hr-hrcl' or location/shortname = 'hr-pcl' or location/shortname = 'wc-swcl')">
        <xsl:if test="@notify_interval = '7 days' or @notify_interval = '30 days' or @notify_interval = '60 days'">
          <xsl:call-template name="notice_template"/>
        </xsl:if>
      </xsl:if>
      <xsl:if test="patron/email = '' and (location/shortname = 'sc-scps' or location/shortname = 'wc-dufur' or location/shortname = 'wc-plane')">
        <xsl:if test="@notify_interval = '7 days' or @notify_interval = '14 days' or @notify_interval = '30 days' or @notify_interval = '60 days'">
          <xsl:call-template name="notice_template"/>
        </xsl:if>
      </xsl:if>
      <xsl:if test="patron/email = '' and not(location/shortname = 'hr-hrhs' or location/shortname = 'hr-cll' or location/shortname = 'hr-hrcl' or location/shortname = 'hr-pcl' or location/shortname = 'sc-scps' or location/shortname = 'wc-dalles' or location/shortname = 'wc-dufur' or location/shortname = 'wc-plane' or location/shortname = 'wc-swcl' or location/shortname = 'um-mf')">
        <xsl:if test="@notify_interval = '7 days' or @notify_interval = '14 days' or @notify_interval = '21 days'">
          <xsl:call-template name="notice_template"/>
        </xsl:if>
      </xsl:if>
     </xsl:if>


  </xsl:template>
 
  <xsl:template name="notice_template">
    <xsl:variable name="name1" select="patron/first_given_name" />
    <xsl:variable name="name2" select="patron/family_name" />
    <xsl:variable name="wholename" select="concat($name1,' ',$name2)"/>
    <xsl:variable name="citystatezip" select="concat(patron/addr_city, ' ', patron/addr_state, ' ', patron/addr_post_code)"/>
    <!-- find longest part of address -->
    <xsl:variable name="name-length" select="string-length($wholename)" />
    <xsl:variable name="s1-length" select="string-length(patron/addr_street1)"/>
    <xsl:variable name="s2-length" select="string-length(patron/addr_street2)"/>
    <xsl:variable name="csz-length" select="string-length($citystatezip)"/>
    <xsl:variable name="l1">
      <xsl:choose>
        <xsl:when test="$name-length &gt; $s1-length">
          <xsl:value-of select="$name-length"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$s1-length"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="l2">
      <xsl:choose>
        <xsl:when test="$s2-length &gt; $l1">
          <xsl:value-of select="$s2-length"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$l1"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="longest">
      <xsl:choose>
        <xsl:when test="$csz-length &gt; $l2">
          <xsl:value-of select="$csz-length"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$l2"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="addr-rmargin" select="163 - ($longest * 4) - 1" />
 
    <fo:page-sequence master-reference="late-notice">
      <fo:flow flow-name="xsl-region-body" font="12pt Helvetica">
 
        <!-- ##### ADDRESS BLOCK ########################################## -->
        <xsl:element name="fo:block">
          <xsl:attribute name="margin-left">4mm</xsl:attribute>
          <xsl:attribute name="margin-top">38mm</xsl:attribute>
          <xsl:attribute name="margin-bottom"><xsl:choose><xsl:when test="not(patron/addr_street2='')">15mm</xsl:when><xsl:otherwise>20mm</xsl:otherwise></xsl:choose></xsl:attribute>
          <xsl:attribute name="margin-right"><xsl:value-of select="$addr-rmargin"/>mm</xsl:attribute>
          <xsl:attribute name="padding">2mm</xsl:attribute>
          <xsl:attribute name="text-transform">uppercase</xsl:attribute>
          <xsl:attribute name="font-weight">bold</xsl:attribute>
          <xsl:attribute name="background">#cccccc</xsl:attribute>
          <fo:block><xsl:value-of select="$wholename"/></fo:block>
          <fo:block><xsl:value-of select="patron/addr_street1"/></fo:block>
          <xsl:if test="not(patron/addr_street2='')">
            <fo:block><xsl:value-of select="patron/addr_street2"/></fo:block>
          </xsl:if>
          <fo:block><xsl:value-of select="$citystatezip"/></fo:block>
        </xsl:element>
 
        <!-- ##### SALUTATION ############################################### -->
        <fo:block text-align="right">
          <xsl:value-of select="$gendate"/>
        </fo:block>
        <fo:block>
          Dear <xsl:value-of select="$wholename"/>:
        </fo:block>

        <!-- ##### VARIABLE LATENESS MESSAGE ######################### -->
        <xsl:choose>
          <!-- Milton Freewater -->
          <xsl:when test="@notify_interval='7 days' and location/shortname='um-mf'">
            <fo:block>
              The following items are 7 days overdue. Please return the items, or contact the
              library to make payment arrangements for your bill. After 30 days, your items will be
              marked lost and you will be billed for the cost of the item.
              If you have not returned your items or made payment arrangements within 60 days, your
              account will be sent to collections. If you feel that you have received this in error
              please call us at 541-938-8247 with any questions.
              
              Thank you.
            </fo:block>
           </xsl:when>
          <xsl:when test="@notify_interval='14 days' and location/shortname='um-mf'">
            <fo:block>
              The following items are 14 days overdue. Please return the items, or contact the
              library to make payment arrangements for your bill. After 30 days, your items will be
              marked lost and you will be billed for the cost of the item.
              If you have not returned your items or made payment arrangements within 60 days, your
              account will be sent to collections. If you feel that you have received this in error
              please call us at 541-938-8247 with any questions.
              
              Thank you.
            </fo:block>
           </xsl:when>
          <xsl:when test="@notify_interval='21 days' and location/shortname='um-mf'">
            <fo:block>
              The following items are 7 days overdue. Please return the items, or contact the
              library to make payment arrangements for your bill. After 30 days, your items will be
              marked lost and you will be billed for the cost of the item.
              If you have not returned your items or made payment arrangements within 60 days, your
              account will be sent to collections. If you feel that you have received this in error
              please call us at 541-938-8247 with any questions.
              
              Thank you.
            </fo:block>
           </xsl:when>
          <xsl:when test="@notify_interval='30 days' and location/shortname='um-mf'">
            <fo:block>
              The following items are 30 days overdue. Your items are now considered lost, and
              your account has been charged for the entire cost of the item. Please return the items,
              or contact the library to make payment arrangements for your bill.
              If you have not returned your items or made payment arrangements within 60 days, your
              account will be sent to collections. If you feel that you have received this in error
              please call us at 541-938-8247 with any questions.
              
              Thank you.
            </fo:block>
           </xsl:when>
          <xsl:when test="@notify_interval='60 days' and location/shortname='um-mf'">
            <fo:block>
              The following items are 60 days overdue. Your items are considered lost, and your
              account has been charged forthe entire cost of the book. Please return the items or
              contact the library to make payment arrangements.
              If you have not returned your items or made payment arrangements within 30 days of this
              letter your account will be sent to collections. If you feel that you have received this
              in error please call us at 541-938-8247 with any questions.
              
              Thank you.
            </fo:block>
           </xsl:when>
          <xsl:when test="@notify_interval='90 days' and location/shortname='um-mf'">
            <fo:block>
              The following items are now 90 days overdue. If you do not return the items, or
              contact the library to make payment arrangements your account will be sent to
              collections within ten days of this letter. 
              If you feel that you have received this in error please call us at 541-938-8247
              with any questions.

              Thank you.
            </fo:block>
           </xsl:when>
          <!-- Hood River Valley High School -->
          <xsl:when test="@notify_interval='7 days' and location/shortname='hr-hrhs'">
            <fo:block>
              At the time of this notice's preparation, the following library materials
              are overdue.  Please return them as soon as possible. Thank you.
            </fo:block>
          </xsl:when>
          <xsl:when test="@notify_interval='14 days' and location/shortname='hr-hrhs'">
            <fo:block>
              At the time of this notice's preparation, this is the final overdue notice. If 
              you have already returned the item(s), please let us know. If 
              not returned, you will be charged for the material on your school account.
            </fo:block>
          </xsl:when>
          <xsl:when test="@notify_interval='30 days' and location/shortname='hr-hrhs'">
            <fo:block>
              At the time of this notice's preparation, the following is a statement for
              your account.  Please return any materials or pay the bill as soon as 
              possible. Please contact the library if you have any questions. Thank you.
            </fo:block>
          </xsl:when>
          <!-- Southern Wasco County PL, Maupin -->
          <xsl:when test="@notify_interval='7 days' and location/shortname='wc-swcl'">
            <fo:block>
              At the time of this notice's preparation, the following Library materials are
              overdue. Please return them as soon as possible. You may call to renew
              <xsl:value-of select="location/phone"/>. Thank you.
            </fo:block>
          </xsl:when>
          <xsl:when test="@notify_interval='14 days' and location/shortname='wc-swcl'">
            <fo:block>
              *** Final Overdue ***
            </fo:block>
            <fo:block margin-top="5mm">
              At the time of this notice's preparation, this is your final notice before being 
              billed for the item's replacement. Call the library at 
              <xsl:value-of select="location/phone"/> with questions. Thank you.
            </fo:block>
          </xsl:when>
          <xsl:when test="@notify_interval='60 days' and location/shortname='wc-swcl'">
            <fo:block>
              The following Library materials are assumed lost. You are sent the 
              following bill(s).  Please return the material(s) or pay the bill.
               If you feel you have received this notice in error, please call
              <xsl:value-of select="location/phone"/>. Thank you.
            </fo:block>
          </xsl:when>
          <!-- Planetree Health Resource Center -->
          <xsl:when test="@notify_interval='7 days' and location/shortname='wc-plane'">
            <fo:block>
              At the time of this notice preparation, the following items are overdue.
              Please return the materials as soon as possible, or call 
              <xsl:value-of select="location/phone"/> to renew. We do not charge 
              overdue fines and always welcome our materials back. 
              If you have returned them, please excuse this notice.
            </fo:block>
          </xsl:when>
          <xsl:when test="@notify_interval='14 days' and location/shortname='wc-plane'">
            <fo:block>
              At the time of this notice preparation, the following items are now very late.
              Please call <xsl:value-of select="location/phone"/> to renew, or use our book drop.
              We do not charge fines and always welcome our materials back so others may benefit. 
              If you have returned them, please excuse this notice. Thank you.
            </fo:block>
          </xsl:when>
          <xsl:when test="@notify_interval='30 days' and location/shortname='wc-plane'">
            <fo:block>
              Please return the following item(s) listed below or contact the library at 
              <xsl:value-of select="location/phone"/> to make arrangements for replacement.
              If you do not resolve the problem, we will bill you so we can 
              replace the materials for others to use. Amnesty is our policy and we
              always welcome our materials back. Thank you.
            </fo:block>
          </xsl:when>
          <xsl:when test="@notify_interval='60 days' and location/shortname='wc-plane'">
            <fo:block>
              Please return the following item(s) listed below or contact the library at 
              <xsl:value-of select="location/phone"/> to make arrangements for payment or
              send check payable to Planetree Health Resource Center, 200 E 4th Street,
              The Dalles, OR 97058. Amnesty is our policy and we
              always welcome our materials back. Thank you.
            </fo:block>
          </xsl:when>
          <!-- Sherman County Public/School Library -->
          <xsl:when test="@notify_interval='7 days' and location/shortname='sc-scps'">
            <fo:block>
              Library records show the following item(s) are overdue. Please
              return them as soon as possible. Please call the library with
              questions at <xsl:value-of select="location/phone"/>. Thank you.
            </fo:block>
          </xsl:when>
          <xsl:when test="@notify_interval='14 days' and location/shortname='sc-scps'">
            <fo:block>
              The following item(s) are very overdue. Please return them immediately
              to avoid being billed for the item(s). Call the library at
              <xsl:value-of select="location/phone"/> with any questions. Thank you.
            </fo:block>
          </xsl:when>
          <xsl:when test="@notify_interval='30 days' and location/shortname='sc-scps'">
            <fo:block>
              This is your final notice before being billed for the replacement of the
              item(s) below. Call the library at
              <xsl:value-of select="location/phone"/> with questions. Thank you.
            </fo:block>
          </xsl:when>
          <xsl:when test="@notify_interval='60 days' and location/shortname='sc-scps'">
            <fo:block>
              The following Library materials are assumed lost. You are sent the 
              following bill(s).  Please return the material(s) or pay the bill.
               If you feel you have received this notice in error, please call
              <xsl:value-of select="location/phone"/>. Thank you.
            </fo:block>
          </xsl:when>
          <!-- The Dalles Wasco County Library -->
          <xsl:when test="@notify_interval='7 days' and location/shortname='wc-dalles'">
            <fo:block>
              At the time of notice preparation, the following item(s) are overdue.
              Please return your item(s) or call to renew.  Thank you. 
            </fo:block>
          </xsl:when>
          <xsl:when test="@notify_interval='14 days' and location/shortname='wc-dalles'">
            <fo:block>
              Our records indicate that library items are overdue and delinquent. 
              Please return them to avoid being billed for their replacement.
            </fo:block>
          </xsl:when>
          <xsl:when test="@notify_interval='60 days' and location/shortname='wc-dalles'">
            <fo:block>
              The following library materials are assumed lost. You are sent the 
              following bills.  If you believe you received this notice in error,
              please contact the library at <xsl:value-of select="location/phone"/>. Thank you.
            </fo:block>
          </xsl:when>
          <!-- Dufur School Community Library -->
          <xsl:when test="@notify_interval='7 days' and location/shortname='wc-dufur'">
            <fo:block>
              The following Library materials are overdue; please return or renew them as soon as possible.
            </fo:block>
          </xsl:when>
          <xsl:when test="@notify_interval='14 days' and location/shortname='wc-dufur'">
            <fo:block>
              The following Library materials are still overdue.  
              Please return them or bring them in for renewal as soon as possible.
            </fo:block>
          </xsl:when>
          <xsl:when test="@notify_interval='30 days' and location/shortname='wc-dufur'">
            <fo:block>
              The following items have not been returned to the library.  Students are not eligible 
              for extracurricular activities (sports, dances, class trips, etc.) until items are returned.
            </fo:block>
          </xsl:when>
          <xsl:when test="@notify_interval='60 days' and location/shortname='wc-dufur'">
            <fo:block>
              The following Library materials have not been returned and are assumed lost.
              Please pay the amount indicated for each lost item at the School Office.
            </fo:block>
          </xsl:when>
          <!-- Hood River County Library District -->
          <!-- Note: this block has a different structure. -->
          <xsl:when test="location/shortname = 'hr-hrcl' or location/shortname = 'hr-pcl' or location/shortname = 'hr-cll'">
            <xsl:choose>
              <xsl:when test="@notify_interval = '7 days'">
                <fo:block>
                  Library records show the above item(s) overdue. If you have returned them, please excuse
                  this notice.
                </fo:block>
                <fo:block margin-top="5mm">
                  To renew, call: Hood River 541-386-2535, Parkdale 541-352-6502, Cascade Locks 541-374-9317
                  or go to: www.hoodriverlibrary.org, click on "My Account" and enter in the 14 digits of
                  your library card number (put in no spaces). Your PIN is usually the last 4 digits
                  of your phone number.
                </fo:block>
              </xsl:when>
              <xsl:when test="@notify_interval = '30 days'">
                <fo:block>
                  Library records show the above item(s) are very overdue. Please return the items to avoid
                  being billed for their replacement.
                </fo:block>
              </xsl:when>
              <xsl:when test="@notify_interval = '60 days'">
                <fo:block>
                  The following Library materials are assumed lost. You are sent the following bills.  
                  If you feel you have received this notice in error, please call one of our branches at 
                  Hood River 541-386-2535, Parkdale 541-352-6502, Cascade Locks 541-374-9317. Thank you.
                </fo:block>
              </xsl:when>
            </xsl:choose>
          </xsl:when>
          <!-- Wave 1 libraries use standard 7/14/21 and standard wording for most of them -->
          <xsl:when test="@notify_interval='7 days' and $lid = 'Pendleton Public'">
            <fo:block>
              FIRST NOTICE:  Library records show the following item(s) overdue.
              Please return or renew them as soon as possible to avoid further charges.
              If you have already returned them, please call the library at 541-966-0380.
              Thank you.
            </fo:block>
          </xsl:when>
          <xsl:when test="@notify_interval='7 days'">
            <fo:block>
              FIRST NOTICE (1 week overdue):  Library records show the following item(s) overdue.
              Please return or renew them as soon as possible to avoid further charges.
              If you have already returned them, please excuse this notice.  Thank you.
            </fo:block>
          </xsl:when>
          <xsl:when test="@notify_interval='14 days'">
            <fo:block>
              SECOND NOTICE (2 weeks overdue):  Library records still show the following item(s) overdue.
              Please return them as soon as possible to avoid being billed for replacement costs. 
              Thank you.
            </fo:block>
          </xsl:when>
          <xsl:when test="@notify_interval='21 days' and location/name[contains(text(), 'Baker')]">
            <fo:block>
              The following item/s are 2 weeks overdue and in final recall. 
              Please return the item/s or contact the Library to arrange payment.
              Materials not returned within two weeks of the date of this notice without
              communicating with the Library will be referred to the District Attorney
              for prosecution.
            </fo:block>
          </xsl:when>
          <xsl:when test="@notify_interval='21 days' and $lid = 'Baker'">
            <fo:block>
              The following item/s are 2 weeks overdue and in final recall. 
              Please return the item/s or contact the Library to arrange payment.
              Materials not returned within two weeks of the date of this notice without
              communicating with the Library will be referred to the District Attorney
              for prosecution.
            </fo:block>
          </xsl:when>
          <xsl:when test="@notify_interval='21 days' and $lid = 'Lake'">
            <fo:block>
              FINAL NOTICE: This is your final notice to return the item(s) listed
              below. You may be blocked from borrowing until this matter is taken care
              of.  Please return overdue materials and pay all fines/fees as soon as
              possible. If items are not returned or paid 10 days after the above date, 
              this account may be sent to Unique Management Services for collections.
              You will be charged an additional $17 if sent to collections. 
              Replacement charges are indicated below. Please contact the library 
              immediately. Thank you.
            </fo:block>
          </xsl:when>
          <xsl:when test="@notify_interval='21 days' and $lid = 'Blue Mountain'">
            <fo:block>
              Our records indicate charges for non-returned library materials remain on
              your library account. Prompt return of the materials or payment of the
              replacement charge is necessary for continued library privileges.
              Outstanding college bills are sent to the Business Office for further
              recovery efforts. Students may not be allowed to register for classes, 
              receive a diploma or be sent grades until their account is cleared. 
              Questions can be directed to 541-278-5915.
            </fo:block>
          </xsl:when>
          <xsl:when test="@notify_interval='21 days' and $lid = 'Treasure Valley'">
            <fo:block>
              REPLACEMENT BILL:  Library records show the item(s) listed below have 
              been declared lost. The amount listed below represents the replacement cost
              for the material(s) plus processing fees. A hold has now been placed on
              your TVCC record until these charges are satisfied. This hold will deny you
              registration, transcripts, financial aid, etc. Please come to the library 
              as soon as possible to pay these charges, or remit to the address above.
              above.
            </fo:block>
          </xsl:when>
          <xsl:when test="@notify_interval='21 days' and $lid = 'Umatilla'">
            <fo:block>
              REPLACEMENT BILL: Item(s) you borrowed are now seriously overdue.  Oregon
              Revised Statutes 357 975 makes it unlawful for any person to willfully
              detain Library property.  If the books are not returned to the library or 
              replacement bill paid, a charge of theft of library materials will be
              placed with the Umatilla Police Department.
            </fo:block>
          </xsl:when>
          <xsl:when test="@notify_interval='21 days' and $lid = 'Pendleton Public'">
            <fo:block>
              FINAL NOTICE:  This is your final notice to return the item(s) listed
              below.  You may be blocked from borrowing until this matter is taken care
              of.  Price below plus a reprocessing fee of $10 will be charged for each lost item.
              Please contact the owning library immediately.  Thank you.
            </fo:block>
           </xsl:when>
           <xsl:when test="@notify_interval='21 days' and $lid = 'Hines Middle'">
            <fo:block>
              FINAL NOTICE (Items Marked Lost):  Your item(s) listed below have now been
              marked LOST. You may be blocked from borrowing until this matter is taken care
              of. Price below plus a reprocessing fee of $10 will be charged for each lost item.
              Please contact the Hines Middle School Library immediately.  Thank you.
            </fo:block>
           </xsl:when>
          <xsl:otherwise>
            <fo:block>
              FINAL NOTICE (3 weeks overdue):  This is your final notice to return the item(s) listed
              below.  You may be blocked from borrowing until this matter is taken care
              of.  Replacement charges are indicated below.  This may also include a processing fee for
              lost items.
              Please contact the owning library immediately.  Thank you.
            </fo:block>
          </xsl:otherwise>
        </xsl:choose>
        <!-- ##### ITEMS TABLE ############################################ -->
        <xsl:for-each select="item">
          <?dbfo-need height="2in" ?>
          <fo:table margin-top="5mm" margin-left="2mm" table-layout="fixed"
                    width="100%">
            <fo:table-body>
              <fo:table-row>
                <fo:table-cell text-transform="capitalize" font-style="italic"
                               border-left="1pt solid black">
                  <fo:block><xsl:value-of select="title" /></fo:block>
                </fo:table-cell>
              </fo:table-row>
            </fo:table-body>
          </fo:table>
          <fo:table margin-bottom="5mm" margin-left="2mm" table-layout="fixed"
                    width="100%" font-size="10pt">
            <fo:table-column column-width="22mm" />
            <fo:table-column column-width="200mm" />
            <fo:table-body>
              <fo:table-row>
                <fo:table-cell border-left="1pt solid black">
                  <fo:block>Due Date</fo:block>
                </fo:table-cell>
                <fo:table-cell font-family="Courier">
                  <fo:block>
                    <xsl:value-of select="due_date" />
                  </fo:block>
                </fo:table-cell>
              </fo:table-row>
              <fo:table-row>
                <fo:table-cell border-left="1pt solid black">
                  <fo:block>Call#</fo:block>
                </fo:table-cell>
                <fo:table-cell font-family="Courier">
                  <fo:block>
                    <xsl:value-of select="call_number" />
                  </fo:block>
                </fo:table-cell>
              </fo:table-row>
              <fo:table-row>
                <fo:table-cell border-left="1pt solid black">
                  <fo:block>Barcode</fo:block>
                </fo:table-cell>
                <fo:table-cell font-family="Courier">
                  <fo:block>
                    <xsl:value-of select="barcode" />
                  </fo:block>
                </fo:table-cell>
              </fo:table-row>
              <xsl:choose>
                <xsl:when test="item_price != $empty_string">
                  <fo:table-row>
                    <fo:table-cell border-left="1pt solid black">
                      <fo:block>Price</fo:block>
                    </fo:table-cell>
                    <fo:table-cell font-family="Courier">
                      <fo:block>
                        <xsl:value-of select="format-number(item_price, '#.00')" />
                      </fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:when>
              </xsl:choose>
            </fo:table-body>
          </fo:table>
        </xsl:for-each>
  
        <!-- ##### STANDARD FOOTER ##################################### -->
        <fo:block margin="3mm" font="10pt Courier">
          <!-- ##### Library URL goes here ########## -->
        </fo:block>
        <fo:block>
          Contact your library for more information:
        </fo:block>
        <fo:block margin-top="3mm" margin-left="3mm">
          <xsl:value-of select="location/name"/>
        </fo:block>
        <fo:table font-size="10pt" width="100%" table-layout="fixed">
          <fo:table-column column-width="20mm" />
          <fo:table-column column-width="200mm" />
          <fo:table-body>
            <fo:table-row margin-left="3mm">
              <fo:table-cell><fo:block>Address</fo:block></fo:table-cell>
              <fo:table-cell font-family="Courier">
                <fo:block>
                  <xsl:value-of select="location/addr_street1"/>
                </fo:block>
                <xsl:if test="not(location/addr_street2='')">
                  <fo:block><xsl:value-of select="location/addr_street2"/></fo:block>
                </xsl:if>
                <fo:block>
                  <xsl:value-of select="location/addr_city"/>, 
                  <xsl:value-of select="location/addr_state"/>           
                  <xsl:value-of select="concat('   ', location/addr_post_code)"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row margin-left="3mm">
              <fo:table-cell><fo:block>Phone</fo:block></fo:table-cell>
              <fo:table-cell font-family="Courier">
                <fo:block><xsl:value-of select="location/phone"/></fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row margin-left="3mm">
              <fo:table-cell><fo:block>Email</fo:block></fo:table-cell>
              <fo:table-cell font-family="Courier">
                   <!-- Pendleton Custom Footer -->
                    <xsl:choose>
                    <xsl:when test="location/shortname='um-pen'">
                        <fo:block>maura.odaniel@ci.pendleton.or.us</fo:block>
                    </xsl:when>
                    <!-- Default Footer -->
               <xsl:otherwise>
                <fo:block><xsl:value-of select="location/email"/></fo:block>
               </xsl:otherwise>
                    </xsl:choose>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>
</xsl:stylesheet>
