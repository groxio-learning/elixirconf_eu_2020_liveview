defmodule MementoWeb.ScoreLiveTest do
  use MementoWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Memento.HighScores

  @create_attrs %{initials: "some initials", score: 42}
  @update_attrs %{initials: "some updated initials", score: 43}
  @invalid_attrs %{initials: nil, score: nil}

  defp fixture(:score) do
    {:ok, score} = HighScores.create_score(@create_attrs)
    score
  end

  defp create_score(_) do
    score = fixture(:score)
    %{score: score}
  end

  describe "Index" do
    setup [:create_score]

    test "lists all scores", %{conn: conn, score: score} do
      {:ok, _index_live, html} = live(conn, Routes.score_index_path(conn, :index))

      assert html =~ "Listing Scores"
      assert html =~ score.initials
    end

    test "saves new score", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.score_index_path(conn, :index))

      assert index_live |> element("a", "New Score") |> render_click() =~
               "New Score"

      assert_patch(index_live, Routes.score_index_path(conn, :new))

      assert index_live
             |> form("#score-form", score: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#score-form", score: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.score_index_path(conn, :index))

      assert html =~ "Score created successfully"
      assert html =~ "some initials"
    end

    test "updates score in listing", %{conn: conn, score: score} do
      {:ok, index_live, _html} = live(conn, Routes.score_index_path(conn, :index))

      assert index_live |> element("#score-#{score.id} a", "Edit") |> render_click() =~
               "Edit Score"

      assert_patch(index_live, Routes.score_index_path(conn, :edit, score))

      assert index_live
             |> form("#score-form", score: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#score-form", score: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.score_index_path(conn, :index))

      assert html =~ "Score updated successfully"
      assert html =~ "some updated initials"
    end

    test "deletes score in listing", %{conn: conn, score: score} do
      {:ok, index_live, _html} = live(conn, Routes.score_index_path(conn, :index))

      assert index_live |> element("#score-#{score.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#score-#{score.id}")
    end
  end

  describe "Show" do
    setup [:create_score]

    test "displays score", %{conn: conn, score: score} do
      {:ok, _show_live, html} = live(conn, Routes.score_show_path(conn, :show, score))

      assert html =~ "Show Score"
      assert html =~ score.initials
    end

    test "updates score within modal", %{conn: conn, score: score} do
      {:ok, show_live, _html} = live(conn, Routes.score_show_path(conn, :show, score))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Score"

      assert_patch(show_live, Routes.score_show_path(conn, :edit, score))

      assert show_live
             |> form("#score-form", score: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#score-form", score: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.score_show_path(conn, :show, score))

      assert html =~ "Score updated successfully"
      assert html =~ "some updated initials"
    end
  end
end
