page 25006872 "TCard Planner"
{
    DataCaptionExpression = PageCaption;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'Test1,Test2,Test3,Planner';
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group()
            {
                usercontrol(TCard; "EB.TCard.Web")
                {

                    trigger ControlAddInReady()
                    var
                        AddInData: BigText;
                    begin
                        TCardMgt.SetLocationCode(LocationCode);
                        TCardMgt.FillAddInData(AddInData);
                        CurrPage.TCard.RecieveInitTCardData(AddInData);
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Planner)
            {
                Caption = 'Planner';
                action("Operation Mode")
                {
                    Image = Log;

                    trigger OnAction()
                    var
                        AddInData: BigText;
                    begin
                        TCardMgt.SetEditMode(FALSE);
                        EditMode := FALSE;
                        SetPageCaption;
                        TCardMgt.FillAddInData(AddInData);
                        CurrPage.TCard.RecieveInitTCardData(AddInData);
                    end;
                }
                action("Configuration Mode")
                {
                    Image = LogSetup;

                    trigger OnAction()
                    var
                        AddInData: BigText;
                    begin
                        TCardMgt.SetEditMode(TRUE);
                        EditMode := TRUE;
                        SetPageCaption;
                        TCardMgt.FillAddInData(AddInData);
                        CurrPage.TCard.RecieveInitTCardData(AddInData);
                    end;
                }
                action(Refresh)
                {
                    Image = Refresh;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        AddInData: BigText;
                    begin
                        TCardMgt.FillAddInData(AddInData);
                        CurrPage.TCard.RecieveRefreshTCardData(AddInData);
                    end;
                }
                action("Switch Location")
                {
                    Image = SwitchCompanies;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        SelectedLocation: Record "14";
                        AddInData: BigText;
                    begin
                        SelectedLocation.SETRANGE("Use As Service Location", TRUE);
                        IF LocationCode <> '' THEN
                            SelectedLocation.GET(LocationCode);

                        IF PAGE.RUNMODAL(PAGE::"Location List", SelectedLocation) = ACTION::LookupOK THEN
                            LocationCode := SelectedLocation.Code;

                        SetPageCaption;

                        TCardMgt.SetLocationCode(LocationCode);
                        TCardMgt.FillAddInData(AddInData);
                        CurrPage.TCard.RecieveInitTCardData(AddInData);
                    end;
                }
                action("Create New Container")
                {
                    Image = NewItem;

                    trigger OnAction()
                    var
                        AddInData: BigText;
                    begin
                        IF NOT EditMode THEN
                            ERROR(GoToEditModeTxt);

                        TCardMgt.CreateNewContainer;
                        TCardMgt.FillAddInData(AddInData);
                        CurrPage.TCard.RecieveRefreshTCardData(AddInData);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        AddInData: BigText;
    begin
        //ServiceNavigationMgt.FillAddInData(AddInData);
        //CurrPage.Navigation.RecieveInitNavigationData(AddInData);
    end;

    trigger OnInit()
    begin
        LocationCode := TCardMgt.GetDefaultLocationCode;
        SetPageCaption;
    end;

    var
        TCardMgt: Codeunit "25006870";
        CurrentResourceNo: Code[20];
        ResourceTimeRegMgt: Codeunit "25006290";
        LocationCode: Code[20];
        PageCaption: Text[255];
        TCardPageLbl: Label 'TCard Planner';
        PageCaptionSep: Text[3];
        EditModeLbl: Label 'EDIT';
        EditMode: Boolean;
        GoToEditModeTxt: Label 'Please switch to configuration mode first.';
        AreYouSureTxt: Label 'Are You sure, You want to delete container box?';

    [Scope('Internal')]
    procedure "TCard::RequestPositionChange"(ContainerEntryNo: Integer; PosX: Integer; PosY: Integer)
    var
        TCardContainer: Record "25006870";
    begin
        IF TCardContainer.GET(ContainerEntryNo) THEN BEGIN
            TCardContainer.PositionX := PosX;
            TCardContainer.PositionY := PosY;
            TCardContainer.MODIFY;
        END;
    end;

    [Scope('Internal')]
    procedure "TCard::RequestSizeChange"(ContainerEntryNo: Integer; Size: Integer)
    var
        TCardContainer: Record "25006870";
    begin
        IF TCardContainer.GET(ContainerEntryNo) THEN BEGIN
            TCardContainer."Configured Size" := Size;
            TCardContainer."Container Size" := TCardContainer."Container Size"::Custom;
            TCardContainer.MODIFY;
        END;
    end;

    [Scope('Internal')]
    procedure "TCard::RequestItemToContainerChange"(ContainerEntryNo: Integer; ItemEntryNo: Code[20]; ItemEntryType: Option)
    var
        TCardMgt: Codeunit "25006870";
        AddInData: BigText;
    begin
        TCardMgt.ItemToContainerChange(ContainerEntryNo, ItemEntryNo, ItemEntryType);
        TCardMgt.SetLocationCode(LocationCode);
        TCardMgt.FillAddInData(AddInData);
        CurrPage.TCard.RecieveRefreshTCardData(AddInData);
    end;

    [Scope('Internal')]
    procedure "TCard::RequestRefreshData"()
    var
        AddInData: BigText;
    begin
        TCardMgt.SetLocationCode(LocationCode);
        TCardMgt.FillAddInData(AddInData);
        CurrPage.TCard.RecieveRefreshTCardData(AddInData);
    end;

    [Scope('Internal')]
    procedure "TCard::OpenItemEditCard"(ItemEntryNo: Code[20]; ItemEntryType: Option Quote,"Order","Return Order",Booking)
    var
        AddInData: BigText;
        ServiceDocument: Record "25006145";
        ServiceBookingCard: Page "25006890";
        ServiceOrderCard: Page "25006183";
    begin
        CASE ItemEntryType OF
            ItemEntryType::Booking:
                BEGIN
                    IF ServiceDocument.GET(ItemEntryType, ItemEntryNo) THEN BEGIN
                        ServiceBookingCard.SETRECORD(ServiceDocument);
                        ServiceBookingCard.RUNMODAL;
                    END;
                END;
            ItemEntryType::Order:
                BEGIN
                    IF ServiceDocument.GET(ItemEntryType, ItemEntryNo) THEN BEGIN
                        ServiceOrderCard.SETRECORD(ServiceDocument);
                        ServiceOrderCard.RUNMODAL;
                    END;
                END;
        END;

        TCardMgt.SetLocationCode(LocationCode);
        TCardMgt.FillAddInData(AddInData);
        CurrPage.TCard.RecieveRefreshTCardData(AddInData);
    end;

    local procedure SetPageCaption()
    var
        EditModeCaption: Text[20];
        Location: Record "14";
    begin
        IF LocationCode <> '' THEN
            PageCaptionSep := ' - '
        ELSE
            PageCaptionSep := '';

        IF EditMode THEN
            EditModeCaption := ' - ' + EditModeLbl
        ELSE
            EditModeCaption := '';

        IF Location.GET(LocationCode) THEN
            PageCaption := TCardPageLbl + PageCaptionSep + Location.Name + EditModeCaption
        ELSE
            PageCaption := TCardPageLbl + PageCaptionSep + LocationCode + EditModeCaption;
    end;

    [Scope('Internal')]
    procedure "TCard::RequestContainerSettings"(ContainerEntryNo: Integer)
    var
        TCardContainer: Record "25006870";
        ContainerCard: Page "25006871";
        AddInData: BigText;
    begin
        IF TCardContainer.GET(ContainerEntryNo) THEN BEGIN
            ContainerCard.SETRECORD(TCardContainer);
            ContainerCard.RUNMODAL;
        END;

        TCardMgt.FillAddInData(AddInData);
        CurrPage.TCard.RecieveInitTCardData(AddInData);
    end;

    [Scope('Internal')]
    procedure "TCard::RequestContainerDelete"(ContainerEntryNo: Integer)
    var
        TCardContainer: Record "25006870";
        AddInData: BigText;
    begin
        IF DIALOG.CONFIRM(AreYouSureTxt, FALSE) THEN BEGIN
            IF TCardContainer.GET(ContainerEntryNo) THEN BEGIN
                TCardContainer.DELETE;
            END;
        END;

        TCardMgt.FillAddInData(AddInData);
        CurrPage.TCard.RecieveInitTCardData(AddInData);
    end;
}

