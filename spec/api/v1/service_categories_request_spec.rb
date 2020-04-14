require "spec_helper"

RSpec.describe ::V1::ServiceCategories do
  include Rack::Test::Methods
  include V1::Helpers::AuthenticatorHelpers

  ENV["PETBOOKING_SECRET"] = "abc123"

  let(:jwt_helper) { JwtHelper.new("petbooking") }
  let(:ancestry_service_category) { create(:service_category) }

  def app
    ::V1::ServiceCategories
  end

  before :all do
    header "Accept", "application/vnd.petbooking-v1+json"
    header "X-Device", "web"
    header "X-Application", "petbooking"
    # create(:role, :client)
  end

  describe "#create" do
    before do
      create(:role, :manager)
    end
    let(:user) { create(:user) }
    let(:valid_params) {{ user_id: user.id, role: "manager", resource_id: 1 }}
    let(:invalid_params) {{ user_id: user.id, role: "cook", resource_id: 1 }}

  	context "when valid" do
      let(:response) { post("/api/user_roles", valid_params) }

      it "returns 201" do
        expect(response.status).to eq(201)
      end

      it "returns user_role" do
        expect(JSON.parse(response.body)['data']['id']).to eq(user.user_role('manager', 1).id)
      end

      context "only email" do
        let(:response) { post("/api/user_roles", valid_params.except(:user_id).merge(email: 'email@email.com')) }

        it "returns 201" do
          expect(response.status).to eq(201)
        end

        it "returns user_role" do
          expect(JSON.parse(response.body)['data']['email']).to eq('email@email.com')
        end
      end
    end

    context "when invalid" do
      context "when role does not exists" do
        let(:response) { post("/api/user_roles", invalid_params) }

        it "returns 404" do
          expect(response.status).to eq(404)
        end
      end
    end
  end

  describe "#index" do
    before do
      create(:role)
      create(:role, :manager)
    end
    let(:user) { create(:user) }
    let(:session) {
      user.sessions.create({
        device: "web",
        application: "petbooking",
        provider: "petbooking",
      })
    }

  	context "when valid" do
      before do
        header "Jwt", session.token
        header "X-Pet-Booking-Session-Token", session.token
        user.add_user_role({ role: 'admin' })
        user.add_user_role({ role: 'manager', resource_type: 'Business', resource_id: 1 })
        sleep(1)
      end
      let(:response) { get("/api/user_roles", { id: user.id }) }

      it "returns 200" do
        expect(response.status).to eq(200)
      end

      it "returns user_roles" do
        expect(JSON.parse(response.body)['data'].length).to eq(3)
      end
    end

    context "when invalid" do
      before do
        header "X-Session-Token", 'lala'
      end
      let(:response) { get("/api/user_roles", { id: 99 }) }

      it "returns 401" do
        expect(response.status).to eq(401)
      end
    end
  end

  describe "#search" do
    before do
      create(:role)
      create(:role, :manager)
    end
    let(:user) { create(:user) }
    let(:session) {
      user.sessions.create({
        device: "web",
        application: "petbooking",
        provider: "petbooking",
      })
    }

    context "when valid" do
      before do
        header "Jwt", session.token
        header "X-Pet-Booking-Session-Token", session.token
        user.add_user_role({ role: 'admin' })
        user.add_user_role({ role: 'manager', resource_type: 'Business', resource_id: 1 })
        UserRole.reindex
      end
      let(:response) { get("/api/user_roles/search", { q: '*' }) }

      it "returns 200" do
        expect(response.status).to eq(200)
      end

      it "returns user_roles" do
        expect(JSON.parse(response.body)['data'].length).to eq(3)
      end
    end

    context "when invalid" do
      let(:response) { get("/api/user_roles/search", { q: 'invalid_q' }) }

      it "returns 200" do
        expect(response.status).to eq(200)
      end

      it "returns 0 user_roles" do
        expect(JSON.parse(response.body)['data'].length).to eq(0)
      end
    end
  end

  describe "#update" do
    before do
      create(:role)
      create(:role, :manager)
    end
    let(:user) { create(:user) }
    let(:session) {
      user.sessions.create({
        device: "web",
        application: "petbooking",
        provider: "petbooking",
      })
    }

    context "when valid" do
      before do
        header "Jwt", session.token
        header "X-Pet-Booking-Session-Token", session.token
        user.add_user_role({ role: 'manager', resource_type: 'Business', resource_id: 1 })
      end
      let(:response) { put("/api/user_roles", { id: user.user_roles.last.id, resource_id: 2 }) }

      it "returns 200" do
        expect(response.status).to eq(200)
      end

      it "returns user_role" do
        expect(JSON.parse(response.body)['data']['resource_id']).to eq(2)
      end
    end
  end

  describe "#delete" do
    before do
      session = user.sessions.create({
        device: "web",
        application: "petbooking",
        provider: "petbooking",
      })
      header "Jwt", session.token
      header "X-Pet-Booking-Session-Token", session.token
      create(:role, :manager)
    end

    let(:user) { create(:user) }
    let(:user_role) { user.add_user_role({ role: "manager", resource_id: 1 }) }
    let(:valid_params) {{ id: user_role.id, resource_id: 1 }}
    let(:invalid_params) {{ id: 9999, resource_id: 1 }}

  	context "when valid" do
      let(:response) { delete("/api/user_roles", valid_params) }

      it "returns 200" do
        expect(response.status).to eq(200)
      end

      it "returns user_role" do
        expect(JSON.parse(response.body)['data']['id']).to eq(user_role.id)
      end
    end

    context "when invalid" do
      context "when role does not exists" do
        let(:response) { delete("/api/user_roles", invalid_params) }

        it "returns 404" do
          expect(response.status).to eq(404)
        end
      end

      context "when user does not has permission" do
        before do
          session = user.sessions.create({
            device: "web",
            application: "petbooking",
            provider: "petbooking",
          })
          header "Jwt", session.token
          header "X-Pet-Booking-Session-Token", session.token
          create(:role, :employment)
        end
        let(:user) { create(:user) }
        let(:user_role) { user.add_user_role({ role: "employment", resource_id: 1 }) }
        let(:response) { delete("/api/user_roles", valid_params) }

        it "returns 401" do
          expect(response.status).to eq(401)
        end
      end
    end
  end

  describe "#has_user_role" do
    before do
      create(:role, :manager)
    end
    let(:user) { create(:user) }
    let(:session) {
      user.sessions.create({
        device: "web",
        application: "petbooking",
        provider: "petbooking",
      })
    }
    let(:user_role) { user.add_user_role({ role: "manager", resource_id: 1 }) }
    let(:valid_params) {{ role: user_role.role.name, resource_id: 1 }}
    let(:invalid_params) {{ role: "cook", resource_id: 1 }}

  	context "when valid" do
      before do
        header "Jwt", session.token
        header "X-Pet-Booking-Session-Token", session.token
      end
      let(:response) { get("/api/user_roles/has_user_role", valid_params) }

      it "returns 200" do
        expect(response.status).to eq(200)
      end

      it "returns same user_role" do
        expect(JSON.parse(response.body)['data']['id']).to eq(user_role.id)
      end
    end

    context "when invalid" do
      before do
        header "Jwt", session.token
        header "X-Pet-Booking-Session-Token", session.token
      end
      let(:response) { get("/api/user_roles/has_user_role", invalid_params) }

      it "returns 404" do
        expect(response.status).to eq(404)
      end
    end
  end

  describe "#has_permission" do
    before do
      Role.delete_all
      create(:role, :manager)
      create(:role, :client)
    end
    let(:user) { create(:user) }
    let(:session) {
      user.sessions.create({
        device: "web",
        application: "petbooking",
        provider: "petbooking",
      })
    }
    let!(:user_role) { user.add_user_role({ role: "manager", resource_id: 1 }) }
    let(:valid_params) {{ key: "event", scope: "resource", action: "create", resource_id: 1 }}
    let(:invalid_params) {{ key: "event", scope: "resource", action: "create", resource_id: 2 }}

  	context "when valid" do
      before do
        header "Jwt", session.token
        header "X-Pet-Booking-Session-Token", session.token
      end
      let(:response) { get("/api/user_roles/has_permission", valid_params) }

      it "returns 200" do
        expect(response.status).to eq(200)
      end

      it "returns user_roles" do
        expect(JSON.parse(response.body)['data'].map { |r| r['id'] }).to eq(user.user_roles.map(&:id))
      end
    end

    context "when invalid" do
      before do
        header "Jwt", session.token
        header "X-Pet-Booking-Session-Token", session.token
      end
      let(:response) { get("/api/user_roles/has_permission", invalid_params) }

      it "returns 401" do
        expect(response.status).to eq(401)
      end
    end
  end

end