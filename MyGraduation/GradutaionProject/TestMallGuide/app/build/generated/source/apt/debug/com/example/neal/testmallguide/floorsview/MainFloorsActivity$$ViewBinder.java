// Generated code from Butter Knife. Do not modify!
package com.example.neal.testmallguide.floorsview;

import android.view.View;
import android.widget.RadioButton;
import butterknife.Unbinder;
import butterknife.internal.Finder;
import butterknife.internal.Utils;
import butterknife.internal.ViewBinder;
import java.lang.IllegalStateException;
import java.lang.Object;
import java.lang.Override;

public class MainFloorsActivity$$ViewBinder<T extends MainFloorsActivity> implements ViewBinder<T> {
  @Override
  public Unbinder bind(final Finder finder, final T target, Object source) {
    InnerUnbinder unbinder = createUnbinder(target);
    View view;
    view = finder.findRequiredView(source, 2131558479, "field 'rgRight'");
    target.rgRight = finder.castView(view, 2131558479, "field 'rgRight'");
    target.radioButtons = Utils.listOf(
        finder.<RadioButton>findRequiredView(source, 2131558480, "field 'radioButtons'"), 
        finder.<RadioButton>findRequiredView(source, 2131558481, "field 'radioButtons'"), 
        finder.<RadioButton>findRequiredView(source, 2131558482, "field 'radioButtons'"), 
        finder.<RadioButton>findRequiredView(source, 2131558483, "field 'radioButtons'"), 
        finder.<RadioButton>findRequiredView(source, 2131558484, "field 'radioButtons'"), 
        finder.<RadioButton>findRequiredView(source, 2131558485, "field 'radioButtons'"), 
        finder.<RadioButton>findRequiredView(source, 2131558486, "field 'radioButtons'"), 
        finder.<RadioButton>findRequiredView(source, 2131558487, "field 'radioButtons'"), 
        finder.<RadioButton>findRequiredView(source, 2131558488, "field 'radioButtons'"));
    return unbinder;
  }

  protected InnerUnbinder<T> createUnbinder(T target) {
    return new InnerUnbinder(target);
  }

  protected static class InnerUnbinder<T extends MainFloorsActivity> implements Unbinder {
    private T target;

    protected InnerUnbinder(T target) {
      this.target = target;
    }

    @Override
    public final void unbind() {
      if (target == null) throw new IllegalStateException("Bindings already cleared.");
      unbind(target);
      target = null;
    }

    protected void unbind(T target) {
      target.rgRight = null;
      target.radioButtons = null;
    }
  }
}
