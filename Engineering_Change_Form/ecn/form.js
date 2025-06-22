$(document).ready(function() {
    // Function to toggle fields based on caused by others radio selection
    function toggleFields() {
        var selectedValue = $('input[name="fld_causedbyothers"]:checked').val();
        if (selectedValue === '1') {
            $('#grp_causalecn').show();
            $('#grp_reason').hide();
        } else if (selectedValue === '0') {
            $('#grp_causalecn').hide();
            $('#grp_reason').show();
        }
    }
    // Run on page load to set initial state
    toggleFields();
    // Run when radio button selection changes
    $('input[name="fld_causedbyothers"]').change(function() {
        toggleFields();
    });
    
    // Add functionality to the issued to list
    // Array to store selected IDs
    let selectedIds = [];
    if ($('#fld_issuedto').val()!='')
        selectedIds = $('#fld_issuedto').val().split(',');
    $('.issued-to-discipline-list').each(function(){
        let listId = $(this).attr('id').replace('disp_id_','');
        if (selectedIds.includes(listId)) {
            $(this).addClass('active'); 
        } else {
            $(this).removeClass('active'); 
        }
    });
    // Handle updates to the input field
    $('#fld_issuedto').change(function(){
        // Update the selectedIds 
        selectedIds = $(this).val().split(',');
        // Update the list items
        $('.issued-to-discipline-list').each(function(){
            let listId = $(this).attr('id').replace('disp_id_','');
            if (selectedIds.includes(listId)) {
                $(this).addClass('active'); 
            } else {
                $(this).removeClass('active'); 
            }
        });
    });
    // Handle click events on list items
    $('.issued-to-discipline-list').click(function(e) {
        // Prevent default anchor behavior
        e.preventDefault();                                  
        let listId = $(this).attr('id').replace('disp_id_', '');     
        if (selectedIds.includes(listId)) {
            // Remove ID if already selected
            selectedIds = selectedIds.filter(id => id !== listId);
        } else {
            // Add ID if not selected
            selectedIds.push(listId);
        }
        // Update input field with comma-separated values
        $('#fld_issuedto').val(selectedIds.join(',')).trigger('change');
    });

    // Disable fields based on form state
    let formState = $('#fld_formstate').val();
    if (formState == 0){                                    //new ecn
        $('.submit-form-field').removeAttr('disabled');
    }else if(formState == 1){                               //reponse required
        $('.submit-form-field').attr('disabled','disabled');
        $('.response-form-field').removeAttr('disabled');
    }else{                                                  //read only
        $('.submit-form-field').attr('disabled','disabled');
        $('.response-form-field').attr('disabled','disabled');
    }
});
