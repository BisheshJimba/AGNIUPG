page 25006013 "Make Card"
{
    // 25.02.2015 EDMS P21
    //   Added field:
    //     Picture

    Caption = 'Make Card';
    PageType = Card;
    SourceTable = Table25006000;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(Code; Code)
                {
                }
                field(Name; Name)
                {
                }
                field(Picture; Picture)
                {
                }
                field(Icon; Icon)
                {
                    Importance = Additional;
                }
                field("Skip Delivery"; "Skip Delivery")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Make)
            {
                Caption = 'Make';
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page 540;
                    RunPageLink = Table ID=CONST(25006000),
                                  No.=FIELD(Code);
                    ShortCutKey = 'Shift+Ctrl+D';
                }
                action("VIN Decoding")
                {
                    Caption = 'VIN Decoding';
                    Image = DesignCodeBehind;

                    trigger OnAction()
                    begin
                        recVINDecoding.SETRANGE("Make Code",Code);
                        PAGE.RUN(PAGE::"VIN Decoding", recVINDecoding);
                    end;
                }
                action("Own Options")
                {
                    Caption = 'Own Options';
                    Image = CheckList;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page 25006499;
                                    RunPageLink = Make Code=FIELD(Code);
                }
                action(Models)
                {
                    Caption = 'Models';
                    Image = ListPage;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page 25006016;
                                    RunPageLink = Make Code=FIELD(Code);
                }
                action("Model Versions")
                {
                    Caption = 'Model Versions';
                    Image = Versions;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page 25006054;
                                    RunPageLink = Item Type=CONST(Model Version),
                                  Make Code=FIELD(Code);
                    RunPageView = SORTING(Item Type,Make Code,Model Code);
                }
            }
        }
    }

    var
        recVINDecoding: Record "25006008";
}

