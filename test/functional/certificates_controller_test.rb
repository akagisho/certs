require 'test_helper'

class CertificatesControllerTest < ActionController::TestCase
  setup do
    @certificate = certificates(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:certificates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create certificate" do
    assert_difference('Certificate.count') do
      post :create, certificate: { checked_at: @certificate.checked_at, common_name: @certificate.common_name, expired_at: @certificate.expired_at, ipv4addr: @certificate.ipv4addr, issuer: @certificate.issuer, note: @certificate.note, organization: @certificate.organization, port: @certificate.port }
    end

    assert_redirected_to certificate_path(assigns(:certificate))
  end

  test "should show certificate" do
    get :show, id: @certificate
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @certificate
    assert_response :success
  end

  test "should update certificate" do
    put :update, id: @certificate, certificate: { checked_at: @certificate.checked_at, common_name: @certificate.common_name, expired_at: @certificate.expired_at, ipv4addr: @certificate.ipv4addr, issuer: @certificate.issuer, note: @certificate.note, organization: @certificate.organization, port: @certificate.port }
    assert_redirected_to certificate_path(assigns(:certificate))
  end

  test "should destroy certificate" do
    assert_difference('Certificate.count', -1) do
      delete :destroy, id: @certificate
    end

    assert_redirected_to certificates_path
  end
end