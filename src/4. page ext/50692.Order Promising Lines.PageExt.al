pageextension 50692 pageextension50692 extends "Order Promising Lines"
{
    // 24.04.2013 EDMS P8
    //   * fix

    var
        ServiceHeaderEDMS: Record "25006145";


    //Unsupported feature: Property Modification (OptionString) on "CrntSourceType(Variable 1010)".

    //var
    //>>>> ORIGINAL VALUE:
    //CrntSourceType :  ,Sales,Requisition Line,Purchase,Item Journal,BOM Journal,Item Ledger Entry,Prod. Order Line,Prod. Order Component,Planning Line,Planning Component,Transfer,Service Order,Job;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //CrntSourceType :  ,Sales,Requisition Line,Purchase,Item Journal,BOM Journal,Item Ledger Entry,Prod. Order Line,Prod. Order Component,Planning Line,Planning Component,Transfer,Service Order,Job,Service Order EDMS;
    //Variable type has not been exported.


    //Unsupported feature: Code Modification on "OnClosePage".

    //trigger OnClosePage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF Accepted = FALSE THEN
      CapableToPromise.RemoveReqLines(CrntSourceID,0,0,TRUE);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    IF Accepted = FALSE THEN
      //CapableToPromise.RemoveReqLines(CrntSourceID,0,0,TRUE); //EDMS
      CapableToPromise.RemoveReqLines(CrntSourceType,CrntSourceID,0,0,TRUE); //EDMS
    */
    //end;


    //Unsupported feature: Code Insertion (VariableCollection) on "OnOpenPage".

    //trigger (Variable: ServiceHeaderEDMS)()
    //Parameters and return type have not been exported.
    //begin
    /*
    */
    //end;


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    OrderPromisingCalculationDone := FALSE;
    Accepted := FALSE;
    IF GETFILTER("Source ID") <> '' THEN
      CASE CrntSourceType OF
        "Source Type"::"Service Order":
          BEGIN
            ServHeader."Document Type" := ServHeader."Document Type"::Order;
            ServHeader."No." := GETRANGEMIN("Source ID");
            ServHeader.FIND;
            SetServHeader(ServHeader);
          END;
        "Source Type"::Job:
          BEGIN
            Job.Status := Job.Status::Open;
    #15..22
          SetSalesHeader(SalesHeader);
          AcceptButtonEnable := SalesHeader.Status = SalesHeader.Status::Open;
      END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..3
      CASE GETRANGEMIN("Source Type") OF //24.04.2013 EDMS P8
    #5..11
      //EDMS >>
        "Source Type"::"Service Order EDMS":
          BEGIN
            ServiceHeaderEDMS."Document Type" := ServiceHeaderEDMS."Document Type"::Order;
            ServiceHeaderEDMS."No." := GETRANGEMIN("Source ID");
            ServiceHeaderEDMS.FIND;
            SetServiceHeaderEDMS(ServiceHeaderEDMS);
            AcceptButtonEnable := ServiceHeaderEDMS.Status = ServiceHeaderEDMS.Status::Open;
          END;
      //EDMS<<
    #12..25
    */
    //end;

    procedure SetServiceHeaderEDMS(var CrntServiceHeader: Record "25006145")
    begin
        AvailabilityMgt.SetServHeaderEDMS(Rec, CrntServiceHeader);

        CrntSourceType := CrntSourceType::"Service Order EDMS";
        CrntSourceID := CrntServiceHeader."No.";
    end;
}

