require "test_helper"

class DogDiagnosis::DiagnosesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get dog_diagnosis_diagnoses_index_url
    assert_response :success
  end

  test "should get questions" do
    get dog_diagnosis_diagnoses_questions_url
    assert_response :success
  end

  test "should get result" do
    get dog_diagnosis_diagnoses_result_url
    assert_response :success
  end
end
