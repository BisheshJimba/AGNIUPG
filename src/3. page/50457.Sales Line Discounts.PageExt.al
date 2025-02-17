pageextension 50457 pageextension50457 extends "Sales Line Discounts"
{
    // 14.01.2014 EDMS P8
    //   * Added fields. Fix filters due to options.
    // 
    // 21.11.2013 EDMS P8
    //   * added fields
    Editable = ENU=Customer,Customer Disc. Group,All Customers,Campaign,Contract,Assembly,Serv. Package,None;
    Editable = false;
    Editable = "Product Subgroup Code";
    Editable = "Product Group Code";
    Editable = false;
    layout
    {

        //Unsupported feature: Property Modification (Level) on "Control 3".


        //Unsupported feature: Property Modification (ControlType) on "Control 3".



        //Unsupported feature: Code Modification on "SalesCodeFilterCtrl(Control 26).OnLookup".

        //trigger OnLookup(var Text: Text): Boolean
        //>>>> ORIGINAL CODE:
        //begin
            /*
            IF SalesTypeFilter = SalesTypeFilter::"All Customers" THEN
              EXIT;

            #4..9
                  ELSE
                    EXIT(FALSE);
                END;
              SalesTypeFilter::"Customer Discount Group":
                BEGIN
                  CustDiscGrList.LOOKUPMODE := TRUE;
                  IF CustDiscGrList.RUNMODAL = ACTION::LookupOK THEN
            #17..25
                  ELSE
                    EXIT(FALSE);
                END;
            END;

            EXIT(TRUE);
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..12
              SalesTypeFilter::"Customer Disc. Group":
            #14..28
              SalesTypeFilter::"Serv. Package":  //14.01.2014 EDMS P8
                BEGIN
                  ServicePackageList.LOOKUPMODE := TRUE;
                  IF ServicePackageList.RUNMODAL = ACTION::LookupOK THEN
                    Text := ServicePackageList.GetSelectionFilter
                  ELSE
                    EXIT(FALSE);
                END;
            #29..31
            */
        //end;

        //Unsupported feature: Property Deletion (CaptionML) on "Control 3".


        //Unsupported feature: Property Deletion (GroupType) on "Control 3".

        modify("Control 5.OnAssistEdit")
        {
            Visible = false;
        }

        //Unsupported feature: Property Deletion (ToolTipML) on "Control 5".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Control 5".


        //Unsupported feature: Property Deletion (Editable) on "Control 5".

        addafter("Control 20")
        {
            group(Filters)
            {
                Caption = 'Filters';
                Visible = IsOnMobile;
                field(GetFilterDescription;GetFilterDescription)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies a filter for which sales line discounts to display.';

                    trigger OnAssistEdit()
                    begin
                        FilterLines;
                        CurrPage.UPDATE(FALSE);
                    end;
                }
            }
        }
        addafter("Control 14")
        {
            field(ABC;ABC)
            {
            }
        }
        addafter("Control 2")
        {
            field("Make Code";"Make Code")
            {
                Visible = false;
            }
            field("Vehicle Serial No.";"Vehicle Serial No.")
            {
                Visible = false;
            }
            field("Item Category Code";"Item Category Code")
            {
            }
        }
        moveafter(SalesCodeFilterCtrl2;"Control 1")
        moveafter("Control 2";"Control 5")
    }

    var
        ServicePackageList: Page "25006161";


    //Unsupported feature: Property Modification (OptionString) on "SalesTypeFilter(Variable 1000)".

    //var
    //>>>> ORIGINAL VALUE:
    //SalesTypeFilter : Customer,Customer Discount Group,All Customers,Campaign,None;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //SalesTypeFilter : Customer,Customer Disc. Group,All Customers,Campaign,Contract,Assembly,Serv. Package,None;
    //Variable type has not been exported.

    var
        ServicePackage: Record "25006134";


    //Unsupported feature: Code Modification on "GetFilterDescription(PROCEDURE 4)".

    //procedure GetFilterDescription();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        GetRecFilters;

        SourceTableName := '';
        #4..26
              IF Cust.FINDFIRST THEN
                Description := Cust.Name;
            END;
          SalesTypeFilter::"Customer Discount Group":
            BEGIN
              SalesSrcTableName := ObjTranslation.TranslateObject(ObjTranslation."Object Type"::Table,340);
              CustDiscGr.SETFILTER(Code,SalesCodeFilter);
        #34..45
              SalesSrcTableName := Text000;
              Description := '';
            END;
        END;

        IF SalesSrcTableName = Text000 THEN
          EXIT(STRSUBSTNO('%1 %2 %3 %4 %5',SalesSrcTableName,SalesCodeFilter,Description,SourceTableName,CodeFilter));
        EXIT(STRSUBSTNO('%1 %2 %3 %4 %5',SalesSrcTableName,SalesCodeFilter,Description,SourceTableName,CodeFilter));
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..29
          SalesTypeFilter::"Customer Disc. Group":
        #31..48
          SalesTypeFilter::"Serv. Package":  //14.01.2014 EDMS P8
            BEGIN
              SalesSrcTableName := ObjTranslation.TranslateObject(ObjTranslation."Object Type"::Table,25006134);
              ServicePackage."No." := SalesCodeFilter;
              IF ServicePackage.FIND THEN
                Description := ServicePackage.Description;
            END;
        #49..53
        */
    //end;
}

