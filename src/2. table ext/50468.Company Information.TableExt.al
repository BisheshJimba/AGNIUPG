tableextension 50468 tableextension50468 extends "Company Information"
{
    // 15.05.2016 EB.P30 EDMS
    //   Added fields:
    //     "Invoice Header Picture"
    //     "Invoice Footer Picture"
    fields
    {
        modify(City)
        {
            TableRelation = IF (Country/Region Code=CONST()) "Post Code".City
                            ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Country/Region Code));
        }
        modify("Ship-to City")
        {
            TableRelation = IF (Ship-to Country/Region Code=CONST()) "Post Code".City
                            ELSE IF (Ship-to Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Ship-to Country/Region Code));
        }
        modify("Post Code")
        {
            TableRelation = IF (Country/Region Code=CONST()) "Post Code".Code
                            ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code".Code WHERE (Country/Region Code=FIELD(Country/Region Code));
        }
        modify("Ship-to Post Code")
        {
            TableRelation = IF (Ship-to Country/Region Code=CONST()) "Post Code".Code
                            ELSE IF (Ship-to Country/Region Code=FILTER(<>'')) "Post Code".Code WHERE (Country/Region Code=FIELD(Ship-to Country/Region Code));
        }
        field(10000;"Enable NCHL-NPI Integration";Boolean)
        {
            Description = 'NCHL-NPI_1.00';
        }
        field(50000;"Post Box No.";Code[20])
        {
        }
        field(50001;"Picture 2";BLOB)
        {
            SubType = Bitmap;
        }
        field(50002;"Accountability Center";Code[10])
        {
            Caption = 'Accountability Center';
            TableRelation = "Accountability Center".Code;
            ValidateTableRelation = true;
        }
        field(50003;"Scheme Related Fields";Boolean)
        {
        }
        field(50004;"Skip Specific Processes";Boolean)
        {
        }
        field(50005;"Phone Pay QR";BLOB)
        {
            SubType = Bitmap;
        }
        field(50500;"CBMS Username";Text[30])
        {
        }
        field(50501;"CBMS Password";Text[30])
        {
            ExtendedDatatype = Masked;
        }
        field(50502;"CBMS Base URL";Text[100])
        {
        }
        field(50503;"Enable CBMS Realtime Sync";Boolean)
        {
        }
        field(50504;"Credit Type Cash Receipt";Boolean)
        {
        }
        field(50505;"Balaju Auto Works";Boolean)
        {
        }
        field(25006950;"Invoice Header Picture";BLOB)
        {
            Caption = 'Invoice Header Picture';
            SubType = Bitmap;
        }
        field(25006960;"Invoice Footer Picture";BLOB)
        {
            Caption = 'Invoice Footer Picture';
            SubType = Bitmap;
        }
        field(25006961;"Enable Complaint for Loan";Boolean)
        {
        }
        field(25006962;"Agni Astha Company";Boolean)
        {
        }
        field(25006963;"Agni Hire Purchase Company";Boolean)
        {
        }
        field(25006966;"IRD Code";Text[250])
        {
        }
        field(25006967;"Nepali Vat Reg. No.";Text[150])
        {
        }
        field(25006969;"Is Logistic";Boolean)
        {
        }
    }


    //Unsupported feature: Code Modification on "GetSystemIndicator(PROCEDURE 8)".

    //procedure GetSystemIndicator();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        Style := "System Indicator Style";
        CASE "System Indicator" OF
          "System Indicator"::None:
        #4..11
            Text := GetDatabaseIndicatorText(FALSE);
          "System Indicator"::"Company+Database":
            Text := GetDatabaseIndicatorText(TRUE);
        END
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..14
        END;
        // Sipradi-YS * Code to display User Location On RTC
        UserPersonalization.RESET;
        UserPersonalization.SETFILTER("User SID",UserProfileMgt.GetUserSID(USERID));
        IF UserPersonalization.FINDFIRST THEN;

        IF UserSetup.GET(USERID) THEN BEGIN
          UserLocation := '('+UserSetup."Default Location"+')'+'('+
          UserPersonalization."Profile ID"+')';
        END;
        IF UserLocation <> '' THEN
          Text := Text + UserLocation;
        // Sipradi-YS
        */
    //end;

    var
        UserSetup: Record "91";
        UserLocation: Text[100];
        UserPersonalization: Record "2000000073";
        UserProfileMgt: Codeunit "25006002";
}

