# Peer-Review for Programming Exercise 2

## Description

For this assignment, you will be giving feedback on the completeness of assignment two: Obscura. To do so, we will give you a rubric to provide feedback. Please give positive criticism and suggestions on how to fix segments of code.

You only need to review code modified or created by the student you are reviewing. You do not have to check the code and project files that the instructor gave out.

Abusive or hateful language or comments will not be tolerated and will result in a grade penalty or be considered a breach of the UC Davis Code of Academic Conduct.

If there are any questions at any point, please email the TA.

## Due Date and Submission Information

See the official course schedule for due date.

A successful submission should consist of a copy of this markdown document template that is modified with your peer review. This review document should be placed into the base folder of the repo you are reviewing in the master branch. The file name should be the same as in the template: `CodeReview-Exercise2.md`. You must also include your name and email address in the `Peer-reviewer Information` section below.

If you are in a rare situation where two peer-reviewers are on a single repository, append your UC Davis user name before the extension of your review file. An example: `CodeReview-Exercise2-username.md`. Both reviewers should submit their reviews in the master branch.

# Solution Assessment

## Peer-reviewer Information

- _name:_ Yiming Feng
- _email:_ ymfeng@ucdavis.edu

### Description

For assessing the solution, you will be choosing ONE choice from: unsatisfactory, satisfactory, good, great, or perfect.

The break down of each of these labels for the solution assessment.

#### Perfect

    Can't find any flaws with the prompt. Perfectly satisfied all stage objectives.

#### Great

    Minor flaws in one or two objectives.

#### Good

    Major flaw and some minor flaws.

#### Satisfactory

    Couple of major flaws. Heading towards solution, however did not fully realize solution.

#### Unsatisfactory

    Partial work, not converging to a solution. Pervasive Major flaws. Objective largely unmet.

---

## Solution Assessment

### Stage 1

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

---

#### Justification

The vessel is centered at the camera the whole time. The cross is drawn well. Everything works properly.

---

### Stage 2

- [ ] Perfect
- [x] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

---

#### Justification

The camera and the vessel is moving with the autoscroll_speed correctly. When there is no user input, the vessel is not moving in the perspective of the camera. All the fields are exported as required.
However there's one tiny flow. Part of the body of the vessel is outside the box when the vessel is at the edge. I think it would be better if the entire vessel can stay inside the box like the push box.

---

### Stage 3

- [ ] Perfect
- [x] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

---

#### Justification

The lerp mechanism is working properly, the camera is following with `follow_speed`, but never go outside of the `leash_distance`, and it's able to catch up with `catchup_speed`
However, variables `box_height`, `box_width` and `cross_size` are exported unexpected. Other than that, everything is good.

---

### Stage 4

- [ ] Perfect
- [x] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

---

#### Justification

The ahead lerp is working fine, it's able to move ahead of the vessel by the `lead_speed`, and after `catchup_delay_duration`, the camera is move back to the center with `catchup_speed`, and the camera will never go outside the `leash_distance`. All the fields are exported as required except for the `cross_size` and `timeStationary`. Another flow I noticed is that the `lead_speed` is a fixed constant and not related to the vessel's speed. This would trigger some bugs because the vessel can speed up. While the vessel is speeding up, the vessel can go in front of the camera, which is not what we want.

---

### Stage 5

- [ ] Perfect
- [ ] Great
- [ ] Good
- [x] Satisfactory
- [ ] Unsatisfactory

---

#### Justification

This stage is not implemented as required. In this implementation, the vessel is not able to stay inside the speedup_zone. It will be push back inside the speedup_zone. And the vessel can't touch the outer pushbox. This camera is implemented as another form a lerp but not a speedup pushzone.
Another flaw is that even though all fields are exported as required, the top_left and bottom_right for both pushbox and speedup_zone is not used. width and height for the pushbox and speedbox is used instead, which disobey the requirement.

---

# Code Style

### Description

Check the scripts to see if the student code adheres to the GDScript style guide.

If sections do not adhere to the style guide, please peramlink the line of code from Github and justify why the line of code has not followed the style guide.

It should look something like this:

- [description of infraction](https://github.com/dr-jam/ECS189L) - this is the justification.

Please refer to the first code review template on how to do a permalink.

#### Style Guide Infractions

- [Variable never used](https://github.com/ensemble-ai/exercise-2-camera-control-ryanffrench/blob/0f927c00c3eb869edccf321b62fcf12417aba520/Obscura/scenes/position_lock.gd#L8C2-L8C10) - the `position` variable is decleared but never used

- [Redundant variable](https://github.com/ensemble-ai/exercise-2-camera-control-ryanffrench/blob/0f927c00c3eb869edccf321b62fcf12417aba520/Obscura/scenes/autoscroll_camera.gd#L5-L9) - the `box_width`, `box_height` and `bottom_left`, `top_right` is essencially different way to define a rectangle, in your implementation, the `bottom_left` and `top_right` is defined based on the `box_width` and `box_height`. There is no need to export both of them out
  - This happen in multiple files. The above is just one example.

#### Style Guide Exemplars

- Uses PascalCase for class names and snake_case for variables, which is consistent with Godot's style guide.
- Consistent 4-space indentation and effective line spacing for readability

---

# Best Practices

### Description

If the student has followed best practices then feel free to point at these code segments as examplars.

If the student has breached the best practices and has done something that should be noted, please add the infraction.

This should be similar to the Code Style justification.

#### Best Practices Infractions

- [Vector = 0](https://github.com/ensemble-ai/exercise-2-camera-control-ryanffrench/blob/0f927c00c3eb869edccf321b62fcf12417aba520/Obscura/scenes/poslock_lerp_camera.gd#L29) - use `Vector3.Zero` instead of `Vector3(0,0,0`

- [Half_size logic](https://github.com/ensemble-ai/exercise-2-camera-control-ryanffrench/blob/0f927c00c3eb869edccf321b62fcf12417aba520/Obscura/scenes/poslock_lerp_camera.gd#L67) - You set `half_size = cross_size / 5`, is this a mistake? If not, I suggest change the variable name `half_size` to something else to above confusion.

- The scenes and scripts for the camera controller are put under the `scenes` folder. I suggest only to scene file under that folder and move all the script files under the `scripts` folder

#### Best Practices Exemplars

- Sufficient comments explaining non-obvious parts of the code.
- [Handle Timer well](https://github.com/ensemble-ai/exercise-2-camera-control-ryanffrench/blob/0f927c00c3eb869edccf321b62fcf12417aba520/Obscura/scenes/lerp_smooth_target_camera.gd#L30-L36) This is a smart way to handle the time without actually using a `Timer` node.
